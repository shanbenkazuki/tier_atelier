class Tier < ApplicationRecord
  authenticates_with_sorcery!

  DEFAULT_FIELD_NUM = 6

  belongs_to :user
  belongs_to :category

  has_many :tier_ranks, dependent: :destroy
  has_many :tier_categories, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :title, presence: true
  validates :images, content_type: ['image/png', 'image/jpeg', 'image/webp']

  has_one_attached :cover_image

  accepts_nested_attributes_for :tier_ranks, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :tier_categories, reject_if: :all_blank, allow_destroy: true

  def self.create_with_images(user, tier_params, images)
    tier = user.tiers.create!(tier_params)
    tier.add_images(images)
    tier
  end

  def self.initialize_from_template(template)
    new(
      category_id: template.category_id,
      title: template.title,
      description: template.description,
      tier_ranks_attributes: template.template_ranks.map { |rank| { name: rank.name, order: rank.order } },
      tier_categories_attributes: template.template_categories.map { |category| { name: category.name, order: category.order } }
    )
  end

  def update_with_images(tier_params, images)
    update!(tier_params)
    add_images(images)
  end

  def category_with_order_zero
    tier_categories.find_by(order: 0)
  end

  def rank_with_order_zero
    tier_ranks.find_by(order: 0)
  end

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

  def add_items_from_template(template)
    return if template.tier_images.blank?

    tier_rank_id = tier_ranks.find_by(order: 0).id
    tier_category_id = tier_categories.find_by(order: 0).id

    template.tier_images.each do |tier_image|
      item = items.build(tier_rank_id:, tier_category_id:)
      item.image.attach(tier_image.blob)
      item.save!
    end
  end
end
