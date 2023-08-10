class TierRank < ApplicationRecord
  belongs_to :tier
  has_many :items

  validates :name, presence: true
  validates :order, presence: true, numericality: { only_integer: true }
end
