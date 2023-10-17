class Tier < ApplicationRecord
  authenticates_with_sorcery!

  DEFAULT_FIELD_NUM = 6

  belongs_to :user
  belongs_to :category

  has_many :tier_ranks, dependent: :destroy
  has_many :tier_categories, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :title, presence: true

  has_one_attached :cover_image

  accepts_nested_attributes_for :tier_ranks, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :tier_categories, reject_if: :all_blank, allow_destroy: true

  def add_images(images)
    return if images.blank?

    tier_category_id = tier_categories.find_by(order: 0).id
    tier_rank_id = tier_ranks.find_by(order: 0).id

    images.compact_blank!
    images.each do |image|
      item = items.build(
        tier_category_id:,
        tier_rank_id:
      )

      item.image.attach(image)
      item.save!
    end
  end
end
