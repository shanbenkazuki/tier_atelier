require 'rails_helper'

RSpec.describe Tier, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    it { should have_many(:tier_ranks).dependent(:destroy) }
    it { should have_many(:tier_categories).dependent(:destroy) }
    it { should have_many(:items).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(150) }
    it { should validate_length_of(:description).is_at_most(300) }
  end

  describe "#category_with_order_zero" do
    let(:tier) { build(:tier) }
    let!(:tier_category) { create(:tier_category, tier:, order: 0) }

    it "orderが0のtier_categoryを返すこと" do
      expect(tier.category_with_order_zero).to eq(tier_category)
    end
  end

  describe "#rank_with_order_zero" do
    let(:tier) { build(:tier) }
    let!(:tier_rank) { create(:tier_rank, tier:, order: 0) }

    it "orderが0のtier_rankを返すこと" do
      expect(tier.rank_with_order_zero).to eq(tier_rank)
    end
  end

  describe "#add_images" do
    let(:tier) { build(:tier) }
    let!(:tier_category) { create(:tier_category, tier:, order: 0) }
    let!(:tier_rank) { create(:tier_rank, tier:, order: 0) }
    let!(:images) { [fixture_file_upload('spec/fixtures/Aldous.png'), fixture_file_upload('spec/fixtures/Arlot.png')] }

    it "提供された画像を持つアイテムをTierに追加する" do
      expect do
        tier.add_images(images)
      end.to change(tier.items, :count).by(2)

      added_items = tier.items.order(created_at: :desc).limit(2)

      expect(added_items.first.image).to be_attached
      expect(added_items.second.image).to be_attached

      expect(added_items.first.tier_category_id).to eq(tier_category.id)
      expect(added_items.first.tier_rank_id).to eq(tier_rank.id)

      expect(added_items.second.tier_category_id).to eq(tier_category.id)
      expect(added_items.second.tier_rank_id).to eq(tier_rank.id)
    end
  end

  describe "#add_images_from_template" do
    let(:tier) { build(:tier) }
    let!(:tier_category) { create(:tier_category, tier:, order: 0) }
    let!(:tier_rank) { create(:tier_rank, tier:, order: 0) }
    let(:template) { create(:template) }
    let(:images) do
      [
        create_blob_and_attach_to(template, Rails.root.join("spec/fixtures/Aldous.png"), 'Aldous.png'),
        create_blob_and_attach_to(template, Rails.root.join("spec/fixtures/Arlot.png"), 'Arlot.png')
      ]
    end

    def create_blob_and_attach_to(record, file_path, filename)
      blob = ActiveStorage::Blob.create_and_upload!(
        io: File.open(file_path),
        filename:
      )
      record.tier_images.attach(blob)
      record.tier_images.last
    end
    it "提供された画像を持つアイテムをTierに追加する" do
      expect do
        tier.add_images_from_template(images)
      end.to change(tier.items, :count).by(2)

      added_items = tier.items.order(created_at: :desc).limit(2)

      expect(added_items.first.image).to be_attached
      expect(added_items.second.image).to be_attached

      expect(added_items.first.tier_category_id).to eq(tier_category.id)
      expect(added_items.first.tier_rank_id).to eq(tier_rank.id)

      expect(added_items.second.tier_category_id).to eq(tier_category.id)
      expect(added_items.second.tier_rank_id).to eq(tier_rank.id)
    end
  end

  describe ".new_from_template" do
    let(:template) do
      double(
        category_id: 1,
        title: 'Sample Title',
        description: 'Sample Description',
        template_ranks: [
          double(name: 'Rank1', order: 1),
          double(name: 'Rank2', order: 2)
        ],
        template_categories: [
          double(name: 'Category1', order: 1),
          double(name: 'Category2', order: 2)
        ]
      )
    end

    subject { Tier.new_from_template(template) }

    it "テンプレートからの属性で新しいTierを初期化する" do
      expect(subject.category_id).to eq(template.category_id)
      expect(subject.title).to eq(template.title)
      expect(subject.description).to eq(template.description)
    end

    it "テンプレートのtemplate_ranksをもとにtier_ranksをセットする" do
      expected_ranks = template.template_ranks.map { |rank| { name: rank.name, order: rank.order } }
      created_ranks = subject.tier_ranks.map { |rank| { name: rank.name, order: rank.order } }
      expect(created_ranks).to match_array(expected_ranks)
    end

    it "テンプレートのtemplate_categoriesをもとにtier_categoriesをセットする" do
      expected_categories = template.template_categories.map { |category| { name: category.name, order: category.order } }
      created_categories = subject.tier_categories.map { |category| { name: category.name, order: category.order } }
      expect(created_categories).to match_array(expected_categories)
    end
  end
end