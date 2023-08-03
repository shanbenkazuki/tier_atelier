class TierList < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :tiers
  has_many_attached :images

  validates :title, presence: true
end
