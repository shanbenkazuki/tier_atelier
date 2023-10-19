class Template < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :tier_template_relationships, dependent: :destroy
  has_many :tiers, through: :tier_template_relationships
end
