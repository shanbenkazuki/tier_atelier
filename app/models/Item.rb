class Item < ApplicationRecord
  belongs_to :tier
  belongs_to :tier_rank
  belongs_to :tier_category

  has_one_attached :image

  after_destroy :purge_attached_image

  private

  def purge_attached_image
    image.purge_later if image.attached?
  end
end
