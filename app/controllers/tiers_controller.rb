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
    @items = Item.new
  end

  def edit
    @tier_categories = @tier.tier_categories.non_zero.sort_by_asc
    @tier_ranks = @tier.tier_ranks.non_zero.sort_by_asc
    @items = @tier.items
  end

  def create
    ActiveRecord::Base.transaction do
      @tier = current_user.tiers.create!(tier_params)

      # 画像の数だけItemテーブルに保存する
      if params[:tier][:images].reject(&:blank?).present?
        # 初期値を取得
        tier_category_id = @tier.tier_categories.find_by(order: 0).id
        tier_rank_id = @tier.tier_ranks.find_by(order: 0).id
        
        params[:tier][:images].reject!(&:blank?)
        params[:tier][:images].each do |image|
          item = @tier.items.build(
            tier_category_id: tier_category_id,
            tier_rank_id: tier_rank_id
          )

          item.image.attach(image)
          item.save!
        end
      end
    end
    redirect_to make_tier_path(@tier), success: t('.success')
  rescue ActiveRecord::RecordInvalid => e
    handle_error("Validation Error: #{e.record.errors.full_messages.to_sentence}")
  rescue StandardError => e
    handle_error("ERROR: #{e.message}\n#{e.backtrace.join("\n")}")
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
        if params[:tier][:images].reject(&:blank?).present?
          params[:tier][:images].reject!(&:blank?)
          params[:tier][:images].each do |image|
            item = @tier.items.build(item_params)
            
            # 初期値を保存する
            tier_category = @tier.tier_categories.find_by(order: 0)
            tier_rank = @tier.tier_ranks.find_by(order: 0)
            
            # リレーションを活用して id のセットを省略
            item.tier_category = tier_category
            item.tier_rank = tier_rank
            
            item.image.attach(image)
            
            item.save!
          end
        end
      end
  
      redirect_to make_tier_path(@tier), success: t('.success')
    rescue StandardError => e
      Rails.logger.error "ERROR: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
  
      @categories = Category.all
      @tier_categories = @tier.tier_categories.non_zero
      @tier_ranks = @tier.tier_ranks.non_zero
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
    params.require(:tier).permit(
      :category_id, 
      :title, 
      :description, 
      :cover_image,
      tier_ranks_attributes: [
        :name, 
        :order
      ],
      tier_categories_attributes: [
        :name, 
        :order
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

  def handle_error(error_message)
    Rails.logger.error error_message
    @tier = Tier.new(tier_params)
    @categories = Category.all
    flash.now[:danger] = t('.fail')
    render :new, status: :unprocessable_entity
  end
end
