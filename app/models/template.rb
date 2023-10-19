class Template < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :template_ranks, dependent: :destroy
  has_many :template_categories, dependent: :destroy

  has_many_attached :tier_images

  def category_with_order_zero
    template_categories.find_by(order: 0)
  end

  def rank_with_order_zero
    template_ranks.find_by(order: 0)
  end
end
