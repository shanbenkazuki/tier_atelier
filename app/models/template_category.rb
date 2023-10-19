class TemplateCategory < ApplicationRecord
  belongs_to :template

  default_scope { order(:order) }

  scope :non_zero, -> { where.not(order: 0) }
end
