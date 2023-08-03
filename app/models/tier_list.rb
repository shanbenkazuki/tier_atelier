class TierList < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :tiers
end
