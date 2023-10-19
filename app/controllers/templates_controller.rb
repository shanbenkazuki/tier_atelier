class TemplatesController < ApplicationController
  before_action :set_template, only: %i[show edit update destroy]
  before_action :set_categories, only: [:new]

  def index
    @templates = Template.all
  end

  def show; end

  def new
    @tier_id = params[:tier_id]
    @template = Template.new
  end

  def edit; end

  def create
    tier = current_user.tiers.find_by(id: params[:template][:tier_id])

    redirect_to root_path, alert: "Invalid tier selection." and return if tier.nil?

    @template = current_user.templates.build(template_params)
    @template.tiers << tier

    if @template.save
      redirect_to @template, notice: "テンプレートの作成に成功しました"
    else
      @categories = Category.all
      render :new, status: :unprocessable_entity
    end
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
