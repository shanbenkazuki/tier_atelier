class Tier < ApplicationRecord
  authenticates_with_sorcery!

  DEFAULT_FIELD_NUM = 6

  belongs_to :user
  belongs_to :category

  has_many :tier_ranks, dependent: :destroy
  has_many :tier_categories, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :title, presence: true

  has_one_attached :cover_image
  
  accepts_nested_attributes_for :tier_ranks, reject_if: :all_blank
  accepts_nested_attributes_for :tier_categories, reject_if: :all_blank
end
