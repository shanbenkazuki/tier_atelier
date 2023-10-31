require 'rails_helper'

RSpec.describe TemplateCategory, type: :model do
  let(:template_category) { build(:template_category) }

  describe "バリデーション" do
    it "nameとorderが適切であれば有効であること" do
      expect(template_category).to be_valid
    end

    describe "nameのバリデーション" do
      it "nameがなければ無効であること" do
        template_category.name = nil
        expect(template_category).to_not be_valid
      end

      it "nameの長さが70文字以内であれば有効であること" do
        template_category.name = "A" * 70
        expect(template_category).to be_valid
      end

      it "nameの長さが70文字を超えると無効であること" do
        template_category.name = "A" * 71
        expect(template_category).to_not be_valid
      end
    end

    describe "orderのバリデーション" do
      it "orderがなければ無効であること" do
        template_category.order = nil
        expect(template_category).to_not be_valid
      end

      it "orderが整数であれば有効であること" do
        template_category.order = 2
        expect(template_category).to be_valid
      end

      it "orderが整数でなければ無効であること" do
        template_category.order = 1.5
        expect(template_category).to_not be_valid
      end

      it "orderが文字列であれば無効であること" do
        template_category.order = "ABC"
        expect(template_category).to_not be_valid
      end
    end
  end

  describe "scopes" do
    let!(:category_with_order_0) { create(:template_category, order: 0) }
    let!(:category_with_order_1) { create(:template_category, order: 1) }
    let!(:category_with_order_2) { create(:template_category, order: 2) }

    describe ".non_zero" do
      it "orderが0ではないカテゴリを返すこと" do
        expect(TemplateCategory.non_zero).to match_array([category_with_order_1, category_with_order_2])
      end
    end
  end
end
