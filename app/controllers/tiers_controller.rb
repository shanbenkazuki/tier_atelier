class TiersController < ApplicationController
  include ApplicationHelper
  before_action :set_categories, only: [:new, :edit]
  before_action :set_tier, only: [:edit]
  before_action :require_login

  def index; end

  def show
    @tier = Tier.find(params[:id])
  end

  def new
    @tier = Tier.new
    Tier::DEFAULT_FIELD_NUM.times { @tier.tier_categories.build }
    Tier::DEFAULT_FIELD_NUM.times { @tier.tier_ranks.build }
  end

  def edit
    @tier.tier_ranks.order(:order)
    @tier.tier_categories.order(:order)
  end

  def create
    ActiveRecord::Base.transaction do
      @tier = current_user.tiers.create!(tier_params)
      save_images
    end
    redirect_to make_tier_path(@tier), success: t('.success')
  rescue ActiveRecord::RecordInvalid => e
    handle_error("Validation Error: #{e.record.errors.full_messages.to_sentence}", Tier.new(tier_params))
  rescue StandardError => e
    handle_error("ERROR: #{e.message}\n#{e.backtrace.join("\n")}", Tier.new(tier_params))
  end

  def update
    ActiveRecord::Base.transaction do
      @tier = current_user.tiers.find(params[:id])
      @tier.update!(tier_params)
      save_images
    end
    redirect_to make_tier_path(@tier), success: t('.success')
  rescue ActiveRecord::RecordInvalid => e
    handle_error("Validation Error: #{e.record.errors.full_messages.to_sentence}", @tier)
  rescue StandardError => e
    handle_error("ERROR: #{e.message}\n#{e.backtrace.join("\n")}", @tier)
  end

  def destroy
    @tier = Tier.find(params[:id])

    if @tier.destroy
      redirect_back fallback_location: root_path, success: 'Tierを削除しました'
    else
      redirect_back fallback_location: root_path, danger: 'Tierの削除に失敗しました'
    end
  end

  def make
    @tier = Tier.find(params[:id])

    set_meta_tags title: @tier.title,
                  og: {
                    image: url_for(@tier.cover_image.blob&.url)
                  },
                  twitter: {
                    image: url_for(@tier.cover_image.blob&.url)
                  }

    tier_categories = TierCategory.where(tier_id: @tier.id).order(:order)
    tier_ranks = TierRank.where(tier_id: @tier.id).order(:order)

    @category_name_and_ids = tier_categories.non_zero.pluck(:name, :id)
    @rank_name_and_ids = tier_ranks.non_zero.pluck(:name, :id)

    @category_id_with_order_zero = tier_categories.find_by(order: 0)&.id
    @rank_id_with_order_zero = tier_ranks.find_by(order: 0)&.id

    @items = Item.where(tier_id: @tier.id)

    @tier_colors = Rails.application.config.tier_colors

    @images_map = {}

    @items.each do |item|
      key = if item.tier_rank_id == @rank_id_with_order_zero && item.tier_category_id == @category_id_with_order_zero
              "uncategorized_unranked"
            else
              "#{item.tier_rank_id}_#{item.tier_category_id}"
            end
      variant = item.image.variant(resize_to_limit: [80, nil]).processed
      image_data = {
        url: url_for(variant.url),
        id: item.id
      }

      @images_map[key] ||= []
      @images_map[key] << image_data
    end
  end

  def search; end

  private

  def tier_params
    params.require(:tier).permit(
      :category_id,
      :title,
      :description,
      :cover_image,
      tier_ranks_attributes: [
        :id,
        :name,
        :order,
        :_destroy
      ],
      tier_categories_attributes: [
        :id,
        :name,
        :order,
        :_destroy
      ]
    )
  end

  def tier_category_params
    params.require(:tier).permit(:name, :order)
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

  def handle_error(error_message, tier)
    Rails.logger.error error_message
    @tier = tier
    @categories = Category.all
    flash.now[:danger] = t('.fail')
    action_name = tier.new_record? ? :new : :edit
    render action_name, status: :unprocessable_entity
  end

  def save_images
    return if params[:tier][:images].compact_blank.blank?

    tier_category_id = @tier.tier_categories.find_by(order: 0).id
    tier_rank_id = @tier.tier_ranks.find_by(order: 0).id

    params[:tier][:images].compact_blank!
    params[:tier][:images].each do |image|
      item = @tier.items.build(
        tier_category_id:,
        tier_rank_id:
      )

      item.image.attach(image)
      item.save!
    end
  end
end
