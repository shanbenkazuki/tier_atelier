class Category < ApplicationRecord
  has_one_attached :category_cover_image
  has_many :tiers, dependent: :restrict_with_exception
  has_many :templates, dependent: :restrict_with_exception

  validates :name, presence: true
end
