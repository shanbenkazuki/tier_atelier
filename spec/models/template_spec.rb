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
    let(:template) { build(:template) }

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(150) }
    it { should validate_length_of(:description).is_at_most(300) }

    it "カバー画像のサイズが3MBを超える場合、無効であること" do
      oversized_file = StringIO.new("a" * 3.1.megabytes)
      template.template_cover_image.attach(io: oversized_file, filename: 'oversized_avatar.jpg', content_type: 'image/jpeg')

      expect(template).to_not be_valid
      expect(template.errors[:template_cover_image]).to include("は、3MB以下のサイズにしてください")
    end

    it "カバー画像のサイズが3MB以下である場合、有効であること" do
      valid_size_file = StringIO.new("a" * 2.9.megabytes)
      template.template_cover_image.attach(io: valid_size_file, filename: 'valid_avatar.jpg', content_type: 'image/jpeg')

      expect(template).to be_valid
    end
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
