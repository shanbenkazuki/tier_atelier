require 'rails_helper'

RSpec.describe TierCategory, type: :model do
  subject { build(:tier_category) }

  describe "associations" do
    it { is_expected.to belong_to(:tier) }
    it { is_expected.to have_many(:items).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(70) }

    it { is_expected.to validate_presence_of(:order) }
    it { is_expected.to validate_numericality_of(:order).only_integer }
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
  end
end
