class TiersController < ApplicationController
  include ApplicationHelper

  def index; end

  def show
    @tier = Tier.find(params[:id])
  end

  def new
    @categories = Category.all
    @tier = Tier.new
  end

  def edit
    @tier = Tier.find(params[:id])

    set_meta_tags title: @tier.title,
    og: {
      image: url_for(@tier.cover_image.blob.url)
    },
    twitter: {
      image: url_for(@tier.cover_image.blob.url)
    }

    tier_categories = TierCategory.where(tier_id: @tier.id).order(:order)
    tier_ranks = TierRank.where(tier_id: @tier.id).order(:order)

    @category_name_and_ids = tier_categories.where.not(order: 0).pluck(:name, :id)
    @rank_name_and_ids = tier_ranks.where.not(order: 0).pluck(:name, :id)

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
      variant = item.image.variant(resize_to_limit: [50, nil]).processed
      image_data = {
        url: url_for(variant.url),
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
      category_column_num = params["tier"]["category_column_num"].to_i
      rank_column_num = params["tier"]["rank_column_num"].to_i
      1.upto(category_column_num) do |i|
        @tier.tier_categories.create!(name: params["tier"]["category_#{i}"], order: i)
      end
      1.upto(rank_column_num) do |i|
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
        item.tier_rank_id = tier_rank.id
        item.tier_category_id = tier_category.id
        item.save!
      end
    end
    redirect_to edit_tier_path(@tier), success: t('.success')
  rescue StandardError => e
    Rails.logger.error "ERROR: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    
    @categories = Category.all
    flash.now[:danger] = t('.fail')
    render :new, status: :unprocessable_entity
  end

  def update; end

  def destroy
    @tier = Tier.find(params[:id])
  
    @tier.items.each do |item|
      item.image.purge_later if item.image.attached?
    end
  
    @tier.destroy
    redirect_to user_path(@tier.user), notice: 'Tier was successfully deleted.'
  end

  def search; end

  private

  def tier_params
    params.require(:tier).permit(:category_id, :title, :description, :cover_image)
  end
end
