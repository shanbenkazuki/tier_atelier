class TiersController < ApplicationController
  def index; end

  def show; end

  def new
    @categories = Category.all
    @tier = Tier.new
  end

  def edit
    @tier = Tier.find(params[:id])

    tier_categories = TierCategory.where(tier_id: @tier.id).order(:order)
    tier_ranks = TierRank.where(tier_id: @tier.id).order(:order)

    @category_name_and_ids = tier_categories.where.not(order: 0).pluck(:name, :id)
    @rank_name_and_ids = tier_ranks.where.not(order: 0).pluck(:name, :id)

    @category_id_with_order_zero = tier_categories.find_by(order: 0)&.id
    @rank_id_with_order_zero = tier_ranks.find_by(order: 0)&.id

    @items = Item.where(tier_id: @tier.id)

    @images_map = {}

    @items.each do |item|
      key = if item.rank_id == @rank_id_with_order_zero && item.category_id == @category_id_with_order_zero
              "uncategorized_unranked"
            else
              "#{item.rank_id}_#{item.category_id}"
            end

      variant = item.image.variant(resize_to_limit: [50, nil]).processed
      image_data = {
        url: Rails.application.routes.url_helpers.rails_representation_path(variant, only_path: true),
        id: item.id
      }

      @images_map[key] ||= []
      @images_map[key] << image_data
    end
  end

  def create
    ActiveRecord::Base.transaction do
      @tier = current_user.tiers.create!(tier_params)
      # 初期値を保存する
      @tier.tier_categories.create!(name: params["tier"]["default_rank"], order: 0)
      @tier.tier_ranks.create!(name: params["tier"]["default_category"], order: 0)
      1.upto(5) do |i|
        @tier.tier_categories.create!(name: params["tier"]["category_#{i}"], order: i)
        @tier.tier_ranks.create!(name: params["tier"]["rank_#{i}"], order: i)
      end
      # 画像の数だけItemテーブルに保存する
      params[:tier][:images].each do |image|
        next if image.is_a?(String)

        item = Item.new
        item.image.attach(io: image, filename: image.original_filename, content_type: image.content_type)
        tier_category = TierCategory.find_by(tier_id: @tier.id, order: 0)
        tier_rank = TierRank.find_by(tier_id: @tier.id, order: 0)
        item.tier_id = @tier.id
        item.rank_id = tier_rank.id
        item.category_id = tier_category.id
        item.save!
      end
    end
    redirect_to edit_tier_path(@tier), success: t('.success')
  rescue StandardError
    @categories = Category.all
    flash.now[:danger] = t('.fail')
    render :new, status: :unprocessable_entity
  end

  def update; end

  def search; end

  private

  def tier_params
    params.require(:tier).permit(:category_id, :title, :description)
  end
end
