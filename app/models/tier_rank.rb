class TierRank < ApplicationRecord
  belongs_to :tier
  has_many :items, dependent: :destroy

  validates :name, presence: true
  validates :order, presence: true, numericality: { only_integer: true }

  scope :non_zero, -> { where.not(order: 0) }
  scope :sort_by_asc, -> { order(order: :asc) }
end
