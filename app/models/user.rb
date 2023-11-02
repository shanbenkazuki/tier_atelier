class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :tiers, dependent: :destroy
  has_many :templates, dependent: :destroy

  has_one_attached :avatar

  validate :avatar_size_validation, if: -> { avatar.attached? }
  validates :name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :password, length: { minimum: 3, maximum: 16 }, format: { with: /\A[a-zA-Z0-9]+\z/, message: 'は英数字のみ設定してください' }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: { case_sensitive: false }, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  private

  def avatar_size_validation
    if avatar.blob.byte_size > 1.megabyte
      avatar.purge
      errors.add(:avatar, 'は、1MB以下のサイズにしてください')
    end
  end
end
