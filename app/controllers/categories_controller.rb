class CategoriesController < ApplicationController
  def show_tiers
    @category = Category.find(params[:id])
    @tiers = @category.tiers.includes(:cover_image_attachment)
  end

  def show_templates
    @category = Category.find(params[:id])
    @templates = @category.templates.includes(:template_cover_image_attachment)
  end
end
