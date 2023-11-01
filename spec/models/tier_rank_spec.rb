require 'rails_helper'

RSpec.describe TierRank, type: :model do
  subject(:tier_rank) { build(:tier_rank) }

  describe "associations" do
    it { should belong_to(:tier) }
    it { should have_many(:items).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(70) }
    it { should validate_presence_of(:order) }
    it { should validate_numericality_of(:order).only_integer }
  end

  describe "scopes" do
    let!(:rank_with_order_0) { create(:tier_rank, order: 0) }
    let!(:rank_with_order_1) { create(:tier_rank, order: 1) }
    let!(:rank_with_order_2) { create(:tier_rank, order: 2) }

    describe ".non_zero" do
      it "orderが0ではないランクを返すこと" do
        expect(TierRank.non_zero).to match_array([rank_with_order_1, rank_with_order_2])
      end
    end
  end
end
