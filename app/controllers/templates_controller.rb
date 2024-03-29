class TemplatesController < ApplicationController
  before_action :set_template, only: %i[show edit update destroy]
  before_action :set_categories, only: [:new, :edit]
  before_action :require_login, except: [:index, :show]
  before_action :authorize_template, only: [:edit, :update, :destroy]

  def index
    @categories = Category.joins(:templates).includes(:category_cover_image_attachment).distinct
    @templates = Template.by_category(params[:category_id]).with_attached_template_cover_image.order(created_at: :desc)
  end

  def show
    setup_template
  end

  def new
    @tier = Tier.find_by(id: params[:tier_id])
    @template = Template.new
    Template::DEFAULT_FIELD_NUM.times { @template.template_categories.build }
    Template::DEFAULT_FIELD_NUM.times { @template.template_ranks.build }
  end

  def edit; end

  def create
    template_parameters = template_params

    # template_categories_attributesにキー"0"のみが存在するか確認
    if template_parameters[:template_categories_attributes].keys == ["0"]
      # キー"1"を追加
      template_parameters[:template_categories_attributes]["1"] = { "name" => "default", "order" => "1" }
    end
    @template = current_user.templates.new(template_parameters)

    if @template.save
      redirect_to template_path(@template), success: t('.success')
    else
      @categories = Category.all
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @template.update(template_params.except(:tier_images))
      @template.tier_images.attach(params[:template][:tier_images]) if params[:template][:tier_images].present?
      @items = @template.tier_images

      @template_colors = Rails.application.config.tier_colors
      @template_images = {}
      @items.each do |item|
        variant_url = url_for(item.variant(resize_to_fill: [80, nil]).processed.url)
        @template_images["default_area"] ||= []
        @template_images["default_area"] << { url: variant_url, id: item.id }
      end
      flash.now[:success] = 'テンプレートを更新しました'
      respond_to do |format|
        format.html { redirect_to @template, notice: "テンプレートを更新しました" }
        format.turbo_stream
      end
      # redirect_to @template, notice: 'テンプレートを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @template.destroy
    redirect_to user_path(current_user), notice: "テンプレートの削除に成功しました", status: :see_other
  end

  def drop_image
    @template = Template.find(params[:id])
    drop_image_id = params[:template][:drop_image]
    target_image = @template.tier_images.find(drop_image_id)
    target_image.purge
    @template_images = {}
    @items = @template.tier_images
    @items.each do |item|
      variant_url = url_for(item.variant(resize_to_fill: [80, nil]).processed.url)
      @template_images["default_area"] ||= []
      @template_images["default_area"] << { url: variant_url, id: item.id }
    end
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end

  # def template_params
  #   params.require(:template).permit(:title, :description, :category_id, :template_cover_image)
  # end

  def template_params
    params.require(:template).permit(
      :category_id,
      :title,
      :description,
      :template_cover_image,
      template_ranks_attributes: [:id, :name, :order, :_destroy],
      template_categories_attributes: [:id, :name, :order, :_destroy]
    )
  end

  def set_categories
    @categories = Category.all
  end

  def setup_template
    @category_labels = @template.template_categories.non_zero.pluck(:name, :id)
    @rank_labels = @template.template_ranks.non_zero.pluck(:name, :id)

    @uncategorized_template_category_id = @template.category_with_order_zero&.id
    @unranked_template_rank_id = @template.rank_with_order_zero&.id

    @items = @template.tier_images

    @template_colors = Rails.application.config.tier_colors

    @template_images = {}

    @items.each do |item|
      variant_url = url_for(item.variant(resize_to_fill: [80, nil]).processed.url)
      @template_images["default_area"] ||= []
      @template_images["default_area"] << { url: variant_url, id: item.id }
    end
  end

  def authorize_template
    if @template
      authorize @template
    else
      raise "No tier instance available for authorization"
    end
  end
end
