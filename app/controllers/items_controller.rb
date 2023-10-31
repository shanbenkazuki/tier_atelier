class ItemsController < ApplicationController
  before_action :set_item, only: [:update, :destroy]
  before_action :require_login
  before_action :authorize_item, only: [:update, :destroy]

  def update
    @item.tier_id = params[:tier_id]
    @item.tier_rank_id = params[:rank_id]
    @item.tier_category_id = params[:category_id]

    if @item.save
      render json: @item, status: :ok
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    logger.error("Error updating item: #{e.message}")
    render json: { error: 'Internal Server Error' }, status: :internal_server_error
  end

  def destroy
    if @item.destroy
      render json: { status: 'success', message: 'Item successfully deleted' }
    else
      render json: { status: 'error', message: 'Failed to delete item' }, status: :unprocessable_entity
    end
  end

  def bulk_update_items
    ActiveRecord::Base.transaction do
      items_params.each do |item_param|
        item = Item.find(item_param[:item_id])
        item.update!(
          tier_category_id: item_param[:tier_category_id],
          tier_rank_id: item_param[:tier_rank_id]
        )
      end
    end
    render json: { message: "更新しました", redirect_url: tier_path(params[:tier_id]) }, status: :ok
  rescue StandardError => e
    render json: { message: "更新に失敗しました", error: e.message }, status: :unprocessable_entity
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def items_params
    params.require(:_json).map do |item_param|
      item_param.permit(:tier_category_id, :tier_rank_id, :item_id)
    end
  end

  def authorize_item
    if @item
      authorize @item
    else
      raise "No tier instance available for authorization"
    end
  end
end
