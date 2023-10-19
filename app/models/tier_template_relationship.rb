class TierTemplateRelationship < ApplicationRecord
  belongs_to :tier
  belongs_to :template
end
