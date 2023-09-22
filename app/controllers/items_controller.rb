class ItemsController < ApplicationController
  before_action :set_tier, only: [:update]

  def update
    item = Item.find(params[:image_id])
    attach_image_to_item(item)
    item.tier_id = @tier.id

    if params[:is_independent] == 'true'
      item.tier_rank_id = TierRank.where(tier_id: @tier.id, order: 0).first.id
      item.tier_category_id = TierCategory.where(tier_id: @tier.id, order: 0).first.id
    else
      item.tier_rank_id = params[:rank_id]
      item.tier_category_id = params[:category_id]
    end

    if item.save
      render json: item, status: :ok
    else
      render json: item.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    logger.error("Error updating item: #{e.message}")
    render json: { error: 'Internal Server Error' }, status: :internal_server_error
  end

  private

  def set_tier
    @tier = Tier.find(params[:id])
  end

  def attach_image_to_item(item)
    uploaded_image = params[:image]
    item.image.attach(io: uploaded_image, filename: uploaded_image.original_filename, content_type: uploaded_image.content_type)
  end
end
