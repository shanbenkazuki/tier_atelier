class Item < ApplicationRecord
  belongs_to :tier
  belongs_to :rank, class_name: 'TierRank'
  belongs_to :category, class_name: 'TierCategory'

  has_one_attached :image

end
