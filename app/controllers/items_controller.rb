class ItemsController < ApplicationController
  before_action :set_item, only: [:update, :destroy]

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

  private

  def set_item
    @item = Item.find(params[:id])
  end
end
