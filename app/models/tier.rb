class Tier < ApplicationRecord
  belongs_to :tier_list

  validates :vertical_name, presence: true
  validates :horizontal_name, presence: true
end
