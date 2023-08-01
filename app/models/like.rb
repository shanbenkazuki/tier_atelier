class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tier_list
end
