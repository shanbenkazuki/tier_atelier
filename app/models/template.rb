class Template < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :template_ranks, dependent: :destroy
  has_many :template_categories, dependent: :destroy

  has_many_attached :tier_images
end
