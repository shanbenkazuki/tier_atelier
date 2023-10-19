class TemplatesController < ApplicationController
  before_action :set_template, only: %i[show edit update destroy]
  before_action :set_categories, only: [:new]

  def index
    @templates = Template.all
  end

  def show; end

  def new
    @tier = Tier.find_by(id: params[:tier_id])
    @template = Template.new
  end

  def edit; end

  def create
    tier = current_user.tiers.find_by(id: params[:tier_id])
    @template = current_user.templates.build(template_params)

    ActiveRecord::Base.transaction do
      @template.save!

      # Itemの画像のコピー
      tier.items.each do |item|
        if item.image.attached?
          @template.tier_images.attach(item.image.blob)
        else
          raise ActiveRecord::Rollback
        end
      end

      # TierCategoryのコピー
      tier.tier_categories.each do |tier_category|
        @template.template_categories.create!(
          name: tier_category.name,
          order: tier_category.order
        )
      end

      # TierRankのコピー
      tier.tier_ranks.each do |tier_rank|
        @template.template_ranks.create!(
          name: tier_rank.name,
          order: tier_rank.order
        )
      end
    end

    redirect_to @template, notice: "テンプレートの作成に成功しました"
  rescue ActiveRecord::RecordInvalid
    @categories = Category.all
    render :new, status: :unprocessable_entity
  end

  def update
    if @template.update(template_params)
      redirect_to @template, notice: "テンプレートの作成に失敗しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @template.destroy
    redirect_to templates_url, notice: "テンプレートの削除に成功しました", status: :see_other
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:title, :description, :category_id)
  end

  def set_categories
    @categories = Category.all
  end
end
