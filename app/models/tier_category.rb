class TierCategory < ApplicationRecord
  belongs_to :tier
  has_many :items, dependent: :destroy

  validates :name, presence: true, length: { maximum: 70 }
  validates :order, presence: true, numericality: { only_integer: true }

  default_scope { order(:order) }

  scope :non_zero, -> { where.not(order: 0) }
end
