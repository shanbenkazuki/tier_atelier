require 'rails_helper'

RSpec.describe TemplateRank, type: :model do
  describe "associations" do
    it { should belong_to(:template) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(70) }
    it { should validate_presence_of(:order) }
    it { should validate_numericality_of(:order).only_integer }
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
