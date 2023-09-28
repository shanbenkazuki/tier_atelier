class TierRank < ApplicationRecord
  belongs_to :tier
  has_many :items, dependent: :destroy

  validates :name, presence: true
  validates :order, presence: true, numericality: { only_integer: true }

  scope :not_zero_order, -> { where.not(order: 0) }
end
