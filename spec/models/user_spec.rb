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
      it "名前がなければ無効であること" do
        user.name = nil
        expect(user).to_not be_valid
      end

      it "名前の長さが2文字未満であれば無効であること" do
        user.name = "A"
        expect(user).to_not be_valid
      end

      it "名前の長さが30文字を超えると無効であること" do
        user.name = "A" * 31
        expect(user).to_not be_valid
      end
    end

    describe "passwordのバリデーション" do
      it "パスワードが3文字未満であれば無効であること" do
        user.password = "AB"
        expect(user).to_not be_valid
      end

      it "パスワードが17文字以上であれば無効であること" do
        user.password = "A" * 17
        expect(user).to_not be_valid
      end

      it "パスワードが英数字以外を含む場合無効であること" do
        user.password = "password@"
        expect(user).to_not be_valid
      end

      it "確認用パスワードがなければ無効であること" do
        user.password_confirmation = nil
        expect(user).to_not be_valid
      end

      it "パスワードと確認用パスワードが一致しなければ無効であること" do
        user.password = "password123"
        user.password_confirmation = "password124"
        expect(user).to_not be_valid
      end
    end

    describe "emailのバリデーション" do
      it "メールがなければ無効であること" do
        user.email = nil
        expect(user).to_not be_valid
      end

      it "メールが重複していれば無効であること" do
        create(:user, email: "test@example.com")
        user.email = "test@example.com"
        expect(user).to_not be_valid
      end

      it "メールの形式が不正であれば無効であること" do
        user.email = "invalid-email"
        expect(user).to_not be_valid
      end
    end
  end
end
