class TemplatesController < ApplicationController
  before_action :set_template, only: %i[show edit update destroy]
  before_action :set_categories, only: [:new, :edit]
  before_action :require_login, except: [:index, :show]
  before_action :authorize_template, only: [:edit, :update, :destroy]

  def index
    @categories = Category.includes(:category_cover_image_attachment).all
    @templates = Template.by_category(params[:category_id]).with_attached_template_cover_image.order(created_at: :desc)
  end

  def show
    setup_template
  end

  def new
    @tier = Tier.find_by(id: params[:tier_id])
    @template = Template.new
  end

  def edit; end

  def create
    tier = current_user.tiers.find_by(id: params[:tier_id])
    @template = current_user.templates.build(template_params)

    authorize @template

    ActiveRecord::Base.transaction do
      @template.save!

      tier.items.each do |item|
        if item.image.attached?
          @template.tier_images.attach(item.image.blob)
        else
          raise ActiveRecord::Rollback
        end
      end

      tier.tier_categories.each do |tier_category|
        @template.template_categories.create!(
          name: tier_category.name,
          order: tier_category.order
        )
      end

      tier.tier_ranks.each do |tier_rank|
        @template.template_ranks.create!(
          name: tier_rank.name,
          order: tier_rank.order
        )
      end
    end

    redirect_to @template, success: t('.success')
  rescue ActiveRecord::RecordInvalid
    @categories = Category.includes(:category_cover_image_attachment).all
    render :new, status: :unprocessable_entity
  end

  def update
    if @template.update(template_params.except(:tier_images))
      @template.tier_images.attach(params[:template][:tier_images]) if params[:template][:tier_images].present?
      redirect_to @template, notice: 'テンプレートを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @template.destroy
    redirect_to user_path(current_user), notice: "テンプレートの削除に成功しました", status: :see_other
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:title, :description, :category_id, :template_cover_image)
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

    @template_images_map = {}

    @items.each do |item|
      variant_url = url_for(item.variant(resize_to_limit: [60, nil]).processed.url)
      @template_images_map["default_area"] ||= []
      @template_images_map["default_area"] << { url: variant_url, id: item.id }
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
