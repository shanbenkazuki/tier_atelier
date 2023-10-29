require 'rails_helper'

RSpec.describe Tier, type: :model do
  let(:tier) { build(:tier) }

  describe "バリデーション" do
    it "タイトルと説明が適切であれば有効であること" do
      expect(tier).to be_valid
    end

    describe "titleのバリデーション" do
      it "タイトルがなければ無効であること" do
        tier.title = nil
        expect(tier).to_not be_valid
        expect(tier.errors[:title]).to include("を入力してください")
      end

      it "タイトルの長さが150文字を超えると無効であること" do
        tier.title = "A" * 151
        expect(tier).to_not be_valid
        expect(tier.errors[:title]).to include("は150文字以内で入力してください")
      end
    end

    describe "descriptionのバリデーション" do
      it "説明の長さが300文字を超えると無効であること" do
        tier.description = "A" * 301
        expect(tier).to_not be_valid
        expect(tier.errors[:description]).to include("は300文字以内で入力してください")
      end
    end
  end
end
