class TiersController < ApplicationController
  include ApplicationHelper
  before_action :set_categories, only: [:new, :edit]
  before_action :set_tier, only: [:edit, :show, :destroy, :arrange, :update_tier_cover_image]
  before_action :require_login
  before_action :authorize_tier, only: [:create, :edit, :update, :destroy, :arrange, :update_tier_cover_image]

  def index; end

  def show
    setup_tier
  end

  def new
    @tier = Tier.new
    Tier::DEFAULT_FIELD_NUM.times { @tier.tier_categories.build }
    Tier::DEFAULT_FIELD_NUM.times { @tier.tier_ranks.build }
  end

  def edit; end

  def create
    save_tier(:create!)
  end

  def update
    set_tier_for_update
    save_tier(:update!)
  end

  def destroy
    if @tier.destroy
      redirect_back fallback_location: root_path, success: 'Tierを削除しました'
    else
      redirect_back fallback_location: root_path, danger: 'Tierの削除に失敗しました'
    end
  end

  def arrange
    set_meta_tags title: @tier.title,
                  og: {
                    image: url_for(@tier.cover_image.blob&.url)
                  },
                  twitter: {
                    image: url_for(@tier.cover_image.blob&.url)
                  }
    setup_tier
  end

  def search; end

  def create_from_template
    template = Template.find(params[:template_id])
    @tier = current_user.tiers.initialize_from_template(template)

    if @tier.save
      @tier.add_items_from_template(template)
      redirect_to arrange_tier_path(@tier), success: t('.success')
    else
      redirect_to templates_path, alert: @tier.errors.full_messages.join(", ")
    end
  end

  def update_tier_cover_image
    if params[:image].present?
      @tier.cover_image.attach(params[:image])

      if @tier.save
        render json: { message: "Cover image updated successfully." }, status: :ok
      else
        render json: { errors: @tier.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Image not provided." }, status: :unprocessable_entity
    end
  end

  private

  def tier_params
    params.require(:tier).permit(
      :category_id,
      :title,
      :description,
      :cover_image,
      tier_ranks_attributes: [:id, :name, :order, :_destroy],
      tier_categories_attributes: [:id, :name, :order, :_destroy]
    )
  end

  def item_params
    params.require(:tier).permit(:image)
  end

  def set_categories
    @categories = Category.all
  end

  def set_tier
    @tier = Tier.find(params[:id])
  end

  def set_tier_for_update
    @tier = current_user.tiers.find(params[:id])
  end

  def save_tier(method)
    ActiveRecord::Base.transaction do
      if method == :create!
        @tier = Tier.create_with_images(current_user, tier_params, params[:tier][:images])
      else
        @tier.update_with_images(tier_params, params[:tier][:images])
      end
    end
    redirect_to arrange_tier_path(@tier), success: t('.success')
  rescue ActiveRecord::RecordInvalid => e
    handle_tier_error("Validation Error: #{e.record.errors.full_messages.to_sentence}")
  rescue StandardError => e
    handle_tier_error("ERROR: #{e.message}\n#{e.backtrace.join("\n")}")
  end

  def handle_tier_error(error_message)
    Rails.logger.error error_message
    @tier ||= Tier.new(tier_params)
    @categories ||= Category.all
    flash.now[:danger] = t('.fail')
    action_name = @tier.new_record? ? :new : :edit
    render action_name, status: :unprocessable_entity
  end

  def setup_tier
    @category_labels = @tier.tier_categories.non_zero.pluck(:name, :id)
    @rank_labels = @tier.tier_ranks.non_zero.pluck(:name, :id)

    @uncategorized_tier_category_id = @tier.category_with_order_zero&.id
    @unranked_tier_rank_id = @tier.rank_with_order_zero&.id

    @items = @tier.items

    @tier_colors = Rails.application.config.tier_colors

    @images_map = {}

    @items.each do |item|
      variant_url = url_for(item.image.variant(resize_to_fill: [60, 60]).processed.url)
      rank_category_key = item.generate_rank_category_key(@unranked_tier_rank_id, @uncategorized_tier_category_id)
      @images_map[rank_category_key] ||= []
      @images_map[rank_category_key] << item.image_data(variant_url)
    end
  end

  def authorize_tier
    authorize @tier || Tier
  end
end
