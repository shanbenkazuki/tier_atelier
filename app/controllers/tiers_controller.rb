class TiersController < ApplicationController
  include ApplicationHelper
  before_action :set_categories, only: [:new, :edit]
  before_action :set_tier, only: [:edit, :show, :destroy, :arrange, :update_tier_cover_image]
  before_action :require_login, except: [:index]
  before_action :authorize_tier, only: [:edit, :update, :destroy, :arrange, :update_tier_cover_image]

  def index
    @categories = Category.includes(:category_cover_image_attachment).all
    @tiers = Tier.by_category(params[:category_id]).with_attached_cover_image
  end

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
    @tier = current_user.tiers.new(tier_params)

    authorize @tier

    @tier.save!

    redirect_to arrange_tier_path(@tier), success: t('.success')
  rescue Pundit::NotAuthorizedError
    redirect_to root_path, danger: "権限がありません"
  rescue ActiveRecord::RecordInvalid => e
    handle_tier_error(e.record.errors.full_messages)
  rescue StandardError => e
    handle_tier_error([e.message], e.backtrace.join("\n"))
  end

  def update
    set_tier_for_update
    update_tier
  end

  def destroy
    if @tier.destroy
      redirect_back fallback_location: root_path, success: 'Tierを削除しました'
    else
      redirect_back fallback_location: root_path, danger: 'Tierの削除に失敗しました'
    end
  end

  def arrange
    @tweet_url = CGI.escape("#{request.base_url}/tiers/#{@tier.id}")
    @tweet_text = CGI.escape("Tierを作成しました\n")
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
    template = Template.find(params[:id])
    @tier = current_user.tiers.new_from_template(template)

    if @tier.save
      @tier.add_images_from_template(template.tier_images) if template.tier_images.present?
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

  def update_tier
    authorize @tier
    @tier.update!(tier_params)

    redirect_to arrange_tier_path(@tier), success: t('.success')
  rescue Pundit::NotAuthorizedError
    redirect_to root_path, danger: "権限がありません"
  rescue ActiveRecord::RecordInvalid => e
    handle_tier_error(e.record.errors.full_messages)
  rescue StandardError => e
    handle_tier_error([e.message], e.backtrace.join("\n"))
  end

  def handle_tier_error(messages, backtrace = nil)
    messages.each { |msg| Rails.logger.error msg }
    Rails.logger.error backtrace if backtrace

    @tier ||= Tier.new(tier_params)
    messages.each do |msg|
      @tier.errors.add(:base, msg)
    end

    @categories ||= Category.includes(:category_cover_image_attachment).all
    flash.now[:danger] = t('.fail')
    action_name = @tier.new_record? ? :new : :edit
    render action_name, status: :unprocessable_entity
  end

  def setup_tier
    @category_labels = @tier.tier_categories.non_zero.pluck(:name, :id)
    @rank_labels = @tier.tier_ranks.non_zero.pluck(:name, :id)

    @uncategorized_tier_category_id = @tier.category_with_order_zero&.id
    @unranked_tier_rank_id = @tier.rank_with_order_zero&.id

    @items = @tier.items.includes(image_attachment: :blob)

    @tier_colors = Rails.application.config.tier_colors

    @images_map = {}

    @items.each do |item|
      variant_url = url_for(item.image.variant(resize_to_fill: [60, 60], convert: "webp").processed.url)
      rank_category_key = item.generate_rank_category_key(@unranked_tier_rank_id, @uncategorized_tier_category_id)
      @images_map[rank_category_key] ||= []
      @images_map[rank_category_key] << item.image_data(variant_url)
    end
  end

  def authorize_tier
    @tier
  end
end
