require 'rails_helper'

RSpec.describe Template, type: :model do
  describe "バリデーション" do
    let(:template) { build(:template) }

    it "タイトルが適切であれば有効であること" do
      expect(template).to be_valid
    end

    describe "titleのバリデーション" do
      it "タイトルがなければ無効であること" do
        template.title = nil
        expect(template).to_not be_valid
        expect(template.errors[:title]).to include("を入力してください")
      end

      it "タイトルの長さが150文字を超えると無効であること" do
        template.title = "A" * 151
        expect(template).to_not be_valid
        expect(template.errors[:title]).to include("は150文字以内で入力してください")
      end

      it "タイトルの長さが150文字であれば有効であること" do
        template.title = "A" * 150
        expect(template).to be_valid
      end
    end

    describe "descriptionのバリデーション" do
      it "説明の長さが300文字を超えると無効であること" do
        template.description = "A" * 301
        expect(template).to_not be_valid
        expect(template.errors[:description]).to include("は300文字以内で入力してください")
      end

      it "説明の長さが300文字であれば有効であること" do
        template.description = "A" * 300
        expect(template).to be_valid
      end
    end
  end

  describe "#category_with_order_zero" do
    let(:template) { build(:template) }
    let!(:template_category) { create(:template_category, template: template, order: 0) }

    it "orderが0のtemplate_categoryを返すこと" do
      expect(template.category_with_order_zero).to eq(template_category)
    end
  end

  describe "#rank_with_order_zero" do
    let(:template) { build(:template) }
    let!(:template_rank) { create(:template_rank, template: template, order: 0) }

    it "orderが0のtemplate_rankを返すこと" do
      expect(template.rank_with_order_zero).to eq(template_rank)
    end
  end
end
