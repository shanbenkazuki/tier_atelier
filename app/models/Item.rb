class Item < ApplicationRecord
  belongs_to :tier
  belongs_to :rank, class_name: 'TierRank'
  belongs_to :category, class_name: 'TierCategory'

  validates :tier_list_id, :rank_id, :category_id, presence: true
end
