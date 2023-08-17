class ItemsController < ApplicationController
  before_action :set_tier, only: [:update]

  def update
    begin
      item = Item.find(params[:image_id])
      attach_image_to_item(item)
  
      tier_category = TierCategory.find_by(tier_id: @tier.id, name: params[:category])
      tier_rank = TierRank.find_by(tier_id: @tier.id, name: params[:rank])
      item.tier_id = @tier.id
      item.rank_id = tier_rank.id
      item.category_id = tier_category.id
  
      if item.save
        render json: item, status: :ok
      else
        render json: item.errors, status: :unprocessable_entity
      end
    rescue => e
      logger.error("Error updating item: #{e.message}")
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end
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
