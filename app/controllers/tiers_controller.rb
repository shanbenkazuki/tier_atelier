class TiersController < ApplicationController
  include ApplicationHelper
  before_action :set_categories, only: [:new, :edit]
  before_action :set_tier, only: [:edit]
  before_action :set_column_numbers, only: [:new, :edit]

  def index; end

  def show
    @tier = Tier.find(params[:id])
  end

  def new
    @tier = Tier.new
    @tier_categories = Array.new(5) { TierCategory.new }
    @tier_ranks = Array.new(5) { TierRank.new }
    @items = Item.new
  end

  def edit
    @tier_categories = @tier.tier_categories.not_zero_order
    @tier_ranks = @tier.tier_ranks.not_zero_order
    @items = @tier.items
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
    redirect_to make_tier_path(@tier), success: t('.success')
  rescue StandardError => e
    Rails.logger.error "ERROR: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    
    @categories = Category.all
    flash.now[:danger] = t('.fail')
    render :new, status: :unprocessable_entity
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        @tier = current_user.tiers.find(params[:id])
        @tier.update!(tier_params)
        
        # Update or create TierCategories
        params["tier"]["category_column_num"].to_i.times do |i|
          name = params["tier"]["category_#{i + 1}"]
          tier_category = @tier.tier_categories.find_or_initialize_by(order: i + 1)
          tier_category.update!(name: name)
        end
  
        # Update or create TierRanks
        params["tier"]["rank_column_num"].to_i.times do |i|
          name = params["tier"]["rank_#{i + 1}"]
          tier_rank = @tier.tier_ranks.find_or_initialize_by(order: i + 1)
          tier_rank.update!(name: name)
        end
  
        # add new images
        if params[:tier][:images]
          params[:tier][:images].each do |image|
            next if image.is_a?(String)
  
            item = @tier.items.new
            item.image.attach(io: image, filename: image.original_filename, content_type: image.content_type)
            tier_category = @tier.tier_categories.find_by(order: 0)
            tier_rank = @tier.tier_ranks.find_by(order: 0)
            item.tier_rank_id = tier_rank.id
            item.tier_category_id = tier_category.id
            item.save!
          end
        end
      end
  
      redirect_to make_tier_path(@tier), success: t('.success')
    rescue StandardError => e
      Rails.logger.error "ERROR: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
  
      @categories = Category.all
      flash.now[:danger] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tier = Tier.find(params[:id])
  
    @tier.items.each do |item|
      item.image.purge_later if item.image.attached?
    end
  
    @tier.destroy
    redirect_to user_path(@tier.user), notice: 'Tier was successfully deleted.'
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

    @category_name_and_ids = tier_categories.not_zero_order.pluck(:name, :id)
    @rank_name_and_ids = tier_ranks.not_zero_order.pluck(:name, :id)

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

  def search; end

  private

  def tier_params
    params.require(:tier).permit(:category_id, :title, :description, :cover_image)
  end

  def set_categories
    @categories = Category.all
  end
  
  def set_tier
    @tier = Tier.find(params[:id])
  end
  
  def set_column_numbers
    default_column_num = 5
    @category_column_num = @tier_categories&.count || default_column_num
    @rank_column_num = @tier_ranks&.count || default_column_num
  end
end
