require 'rails_helper'

RSpec.describe TemplateCategory, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(70) }
    it { is_expected.to validate_presence_of(:order) }
    it { is_expected.to validate_numericality_of(:order).only_integer }
  end

  describe "associations" do
    it { is_expected.to belong_to(:template) }
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
