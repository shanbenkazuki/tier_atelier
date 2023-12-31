class Template < ApplicationRecord
  belongs_to :user
  belongs_to :category

  DEFAULT_FIELD_NUM = 11

  DEFAULT_RANK_FIELD_NUM = 6
  DEFAULT_CATEGORY_FIELD_NUM = 1

  has_many :template_ranks, dependent: :destroy
  has_many :template_categories, dependent: :destroy

  has_many_attached :tier_images
  has_one_attached :template_cover_image

  accepts_nested_attributes_for :template_ranks, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :template_categories, reject_if: :all_blank, allow_destroy: true

  validate :file_size_validation, if: -> { template_cover_image.attached? }
  validates :title, presence: true, length: { maximum: 150 }
  validates :description, length: { maximum: 300 }

  scope :by_category, ->(category_id) { where(category_id:) if category_id.present? }

  def category_with_order_zero
    template_categories.find_by(order: 0)
  end

  def rank_with_order_zero
    template_ranks.find_by(order: 0)
  end

  private

  def file_size_validation
    if template_cover_image.blob.byte_size > 3.megabyte
      template_cover_image.purge
      errors.add(:template_cover_image, 'は、3MB以下のサイズにしてください')
    end
  end
end
