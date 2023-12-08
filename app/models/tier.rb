class Tier < ApplicationRecord
  authenticates_with_sorcery!

  DEFAULT_FIELD_NUM = 6

  belongs_to :user, optional: true
  belongs_to :category

  has_one_attached :cover_image

  has_many :tier_ranks, dependent: :destroy
  has_many :tier_categories, dependent: :destroy
  has_many :items, dependent: :destroy

  validate :file_size_validation, if: -> { cover_image.attached? }
  validates :title, presence: true, length: { maximum: 150 }
  validates :description, length: { maximum: 300 }

  accepts_nested_attributes_for :tier_ranks, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :tier_categories, reject_if: :all_blank, allow_destroy: true

  scope :by_category, ->(category_id) { where(category_id:) if category_id.present? }

  def self.new_from_template(template)
    new(
      category_id: template.category_id,
      title: template.title,
      description: template.description,
      tier_ranks_attributes: template.template_ranks.map { |rank| { name: rank.name, order: rank.order } },
      tier_categories_attributes: template.template_categories.map { |category| { name: category.name, order: category.order } }
    )
  end

  def category_with_order_zero
    tier_categories.find_by(order: 0)
  end

  def rank_with_order_zero
    tier_ranks.find_by(order: 0)
  end

  def add_images_from_template(images)
    images.each do |image|
      create_item_with_image(image.blob)
    end
  end

  private

  def create_item_with_image(image_or_blob)
    tier_category_id = tier_categories.find_by(order: 0).id
    tier_rank_id = tier_ranks.find_by(order: 0).id

    item = items.build(tier_category_id:, tier_rank_id:)
    item.image.attach(image_or_blob)
    item.save!
  end

  def file_size_validation
    if cover_image.blob.byte_size > 1.megabyte
      cover_image.purge
      errors.add(:cover_image, 'は、1MB以下のサイズにしてください')
    end
  end
end
