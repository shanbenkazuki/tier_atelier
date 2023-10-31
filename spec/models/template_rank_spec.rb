require 'rails_helper'

RSpec.describe TemplateRank, type: :model do
  let(:template_rank) { build(:template_rank) }

  describe "バリデーション" do
    it "nameとorderが適切であれば有効であること" do
      expect(template_rank).to be_valid
    end

    describe "nameのバリデーション" do
      it "nameがなければ無効であること" do
        template_rank.name = nil
        expect(template_rank).to_not be_valid
      end

      it "nameの長さが70文字以内であれば有効であること" do
        template_rank.name = "A" * 70
        expect(template_rank).to be_valid
      end

      it "nameの長さが70文字を超えると無効であること" do
        template_rank.name = "A" * 71
        expect(template_rank).to_not be_valid
      end
    end

    describe "orderのバリデーション" do
      it "orderがなければ無効であること" do
        template_rank.order = nil
        expect(template_rank).to_not be_valid
      end

      it "orderが整数であれば有効であること" do
        template_rank.order = 2
        expect(template_rank).to be_valid
      end

      it "orderが整数でなければ無効であること" do
        template_rank.order = 1.5
        expect(template_rank).to_not be_valid
      end

      it "orderが文字列であれば無効であること" do
        template_rank.order = "ABC"
        expect(template_rank).to_not be_valid
      end
    end
  end

  describe "scopes" do
    let!(:rank_with_order_0) { create(:template_rank, order: 0) }
    let!(:rank_with_order_1) { create(:template_rank, order: 1) }
    let!(:rank_with_order_2) { create(:template_rank, order: 2) }

    describe ".non_zero" do
      it "orderが0ではないランクを返すこと" do
        expect(TemplateRank.non_zero).to match_array([rank_with_order_1, rank_with_order_2])
      end
    end
  end
end
