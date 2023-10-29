require 'rails_helper'

RSpec.describe TierCategory, type: :model do
  let(:tier_category) { build(:tier_category) }

  describe "バリデーション" do
    it "nameとorderが適切であれば有効であること" do
      expect(tier_category).to be_valid
    end

    describe "nameのバリデーション" do
      it "nameがなければ無効であること" do
        tier_category.name = nil
        expect(tier_category).to_not be_valid
      end

      it "nameの長さが70文字を超えると無効であること" do
        tier_category.name = "A" * 71
        expect(tier_category).to_not be_valid
      end
    end

    describe "orderのバリデーション" do
      it "orderがなければ無効であること" do
        tier_category.order = nil
        expect(tier_category).to_not be_valid
      end

      it "orderが整数でなければ無効であること" do
        tier_category.order = 1.5
        expect(tier_category).to_not be_valid
      end

      it "orderが文字列であれば無効であること" do
        tier_category.order = "ABC"
        expect(tier_category).to_not be_valid
      end
    end
  end

  describe "scopes" do
    let!(:category_with_order_0) { create(:tier_category, order: 0) }
    let!(:category_with_order_1) { create(:tier_category, order: 1) }
    let!(:category_with_order_2) { create(:tier_category, order: 2) }

    describe ".non_zero" do
      it "orderが0ではないカテゴリを返すこと" do
        expect(TierCategory.non_zero).to match_array([category_with_order_1, category_with_order_2])
      end
    end

    describe ".sort_by_asc" do
      it "orderの昇順でカテゴリを返すこと" do
        expect(TierCategory.sort_by_asc).to eq([category_with_order_0, category_with_order_1, category_with_order_2])
      end
    end
  end
end
