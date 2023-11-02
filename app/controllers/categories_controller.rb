class CategoriesController < ApplicationController
  def show_tiers
    @category = Category.find(params[:id])
    @tiers = @category.tiers
  end

  def show_templates
    @category = Category.find(params[:id])
    @templates = @category.templates
  end
end
