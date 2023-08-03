class Tier < ApplicationRecord
  belongs_to :tier_list

  validates :vertical_label, presence: true
  validates :horizontal_label, presence: true
end
