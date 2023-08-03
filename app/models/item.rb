class Item < ApplicationRecord
  belongs_to :tier_list

  has_many_attached :images
end
