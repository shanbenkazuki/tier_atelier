class Item < ApplicationRecord
  belongs_to :tier
  belongs_to :tier_rank
  belongs_to :tier_category

  has_one_attached :image

  after_destroy :purge_attached_image

  validate :file_size_validation, if: -> { image.attached? }

  def generate_rank_category_key(rank_id_with_order_zero, category_id_with_order_zero)
    if tier_rank_id == rank_id_with_order_zero && tier_category_id == category_id_with_order_zero
      "unranked_uncategorized"
    else
      "#{tier_rank_id}_#{tier_category_id}"
    end
  end

  def image_data(variant_url)
    {
      url: variant_url,
      id:
    }
  end

  private

  def purge_attached_image
    image.purge_later if image.attached?
  end

  def file_size_validation
    if image.blob.byte_size > 1.megabyte
      image.purge
      errors.add(:image, 'は、1MB以下のサイズにしてください')
    end
  end
end
