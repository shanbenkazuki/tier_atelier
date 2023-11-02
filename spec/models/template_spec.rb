require 'rails_helper'

RSpec.describe Template, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    it { should have_many(:template_ranks).dependent(:destroy) }
    it { should have_many(:template_categories).dependent(:destroy) }
    it { should have_many_attached(:tier_images) }
    it { should have_one_attached(:template_cover_image) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(150) }
    it { should validate_length_of(:description).is_at_most(300) }
  end

  describe "#category_with_order_zero" do
    let(:template) { build(:template) }
    let!(:template_category) { create(:template_category, template:, order: 0) }

    it "orderが0のtemplate_categoryを返すこと" do
      expect(template.category_with_order_zero).to eq(template_category)
    end
  end

  describe "#rank_with_order_zero" do
    let(:template) { build(:template) }
    let!(:template_rank) { create(:template_rank, template:, order: 0) }

    it "orderが0のtemplate_rankを返すこと" do
      expect(template.rank_with_order_zero).to eq(template_rank)
    end
  end
end
