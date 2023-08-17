class Tier < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :tier_ranks, dependent: :destroy
  has_many :tier_categories, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :title, presence: true
end
