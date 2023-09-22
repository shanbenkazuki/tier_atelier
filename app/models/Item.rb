class Item < ApplicationRecord
  belongs_to :tier
  belongs_to :tier_rank
  belongs_to :tier_category

  has_one_attached :image
end
