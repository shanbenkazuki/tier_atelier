require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "バリデーション" do
    it "名前、メール、パスワードが適切であれば有効であること" do
      expect(user).to be_valid
    end

    describe "avatarのバリデーション" do
      it "avatarのサイズが1MBを超える場合、無効であること" do
        oversized_file = StringIO.new("a" * 1.1.megabytes)
        user.avatar.attach(io: oversized_file, filename: 'oversized_avatar.jpg', content_type: 'image/jpeg')

        expect(user).to_not be_valid
        expect(user.errors[:avatar]).to include("は、1MB以下のサイズにしてください")
      end

      it "avatarのサイズが1MB以下である場合、有効であること" do
        valid_size_file = StringIO.new("a" * 0.9.megabytes)
        user.avatar.attach(io: valid_size_file, filename: 'valid_avatar.jpg', content_type: 'image/jpeg')

        expect(user).to be_valid
      end
    end

    describe "nameのバリデーション" do
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_least(2).is_at_most(30) }
    end

    describe "passwordのバリデーション" do
      it { should validate_length_of(:password).is_at_least(3).is_at_most(16) }
      it { should validate_confirmation_of(:password) }
      it { should validate_presence_of(:password_confirmation) }
      it do
        should allow_values('password1', 'PASSWORD', 'Pass123').for(:password)
        should_not allow_values('パスワード', 'password!@#', '   ').for(:password).with_message('は英数字のみ設定してください')
      end
    end

    describe "emailのバリデーション" do
      subject { User.new(name: "Sample Name", email: "sample@example.com", password: "password", password_confirmation: "password") }
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }
      it { should allow_value('test@example.com').for(:email) }
      it { should_not allow_value('test').for(:email) }
      it { should_not allow_value('test@').for(:email) }
      it { should_not allow_value('@example.com').for(:email) }
    end
  end
end
