class TiersController < ApplicationController
  def index; end

  def new
    @categories = Category.all
    @tier = Tier.new
  end

  def create
    ActiveRecord::Base.transaction do
      @tier = current_user.tiers.create!(tier_params)
      1.upto(5) do |i|
        @tier.tier_categories.create!(name: params["tier"]["category_#{i}"], order: i)
        @tier.tier_ranks.create!(name: params["tier"]["rank_#{i}"], order: i)
      end
    end
    redirect_to edit_tier_path(@tier), success: t('.success')
  rescue => e
    @categories = Category.all
    flash.now[:danger] = t('.fail')
    render :new, status: :unprocessable_entity
  end

  def edit
    @tier = Tier.find(params[:id])
    @images = @tier.images.blobs.map do |blob|
      variant = blob.variant(resize_to_limit: [50, nil]).processed
      Rails.application.routes.url_helpers.rails_representation_path(variant, only_path: true)
    end
  end

  def update
    
  end

  def show; end

  def search; end

  private

  def tier_params
    params.require(:tier).permit(:category_id, :title, :description, images: [])
  end
end
