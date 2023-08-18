class TiersController < ApplicationController
  def index; end

  def new
    @categories = Category.all
    @tier = Tier.new
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
  rescue => e
    @categories = Category.all
    flash.now[:danger] = t('.fail')
    render :new, status: :unprocessable_entity
  end

  def edit
    @tier = Tier.find(params[:id])

    # Tier表示用のデータを取得する
    @category_name_and_ids = TierCategory.where(tier_id: @tier.id).where.not(order: 0).order(:order).pluck(:name, :id)
    @rank_name_and_ids = TierRank.where(tier_id: @tier.id).where.not(order: 0).order(:order).pluck(:name, :id)
    @items = Item.where(tier_id: @tier.id)
    # 画像のidを配列で取得する
    @image_ids = @items.map(&:id)
    
    @images_map = {}
    @category_ids = TierCategory.where(tier_id: @tier.id).where.not(order: 0).order(:order).pluck(:id)
    @rank_ids = TierRank.where(tier_id: @tier.id).where.not(order: 0).order(:order).pluck(:id)

    @category_id_with_order_zero = TierCategory.where(tier_id: @tier.id, order: 0).pluck(:id).first
    @rank_id_with_order_zero = TierRank.where(tier_id: @tier.id, order: 0).pluck(:id).first

    @items.each do |item|
      if item.rank_id == @rank_id_with_order_zero && item.category_id == @category_id_with_order_zero
        variant = item.image.variant(resize_to_limit: [50, nil]).processed
        image_data = {
          url: Rails.application.routes.url_helpers.rails_representation_path(variant, only_path: true),
          id: item.id
        }
        @images_map["uncategorized_unranked"] ||= []
        @images_map["uncategorized_unranked"] << image_data
      end
    end
    
    @rank_ids.each do |rank_id|
      @category_ids.each do |category_id|
        items = @items.select do |i| 
          i.rank_id == rank_id && i.category_id == category_id
        end
        @images_map["#{rank_id}_#{category_id}"] = items.map do |item|
          variant = item.image.variant(resize_to_limit: [50, nil]).processed
          {
            url: Rails.application.routes.url_helpers.rails_representation_path(variant, only_path: true),
            id: item.id
          }
        end
      end
    end
  end

  def update
    
  end

  def show; end

  def search; end

  private

  def tier_params
    params.require(:tier).permit(:category_id, :title, :description)
  end
end
