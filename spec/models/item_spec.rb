require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { build(:item) }
  let(:rank_id_with_order_zero) { create(:tier_rank, order: 0).id }
  let(:category_id_with_order_zero) { create(:tier_category, order: 0).id }

  describe "associations" do
    it { is_expected.to belong_to(:tier) }
    it { is_expected.to belong_to(:tier_rank) }
    it { is_expected.to belong_to(:tier_category) }
    it { is_expected.to respond_to(:image) }
  end

  describe "validations" do
    let(:item) { build(:item) }

    it "Tier画像のサイズが1MBを超える場合、無効であること" do
      oversized_file = StringIO.new("a" * 1.1.megabytes)
      item.image.attach(io: oversized_file, filename: 'oversized_avatar.jpg', content_type: 'image/jpeg')

      expect(item).to_not be_valid
      expect(item.errors[:image]).to include("は、1MB以下のサイズにしてください")
    end

    it "Tier画像のサイズが1MB以下である場合、有効であること" do
      valid_size_file = StringIO.new("a" * 0.9.megabytes)
      item.image.attach(io: valid_size_file, filename: 'valid_avatar.jpg', content_type: 'image/jpeg')

      expect(item).to be_valid
    end
  end

  describe "#generate_rank_category_key" do
    context "tier_rank_idとtier_category_idがorderが0のものと一致する場合" do
      it "unranked_uncategorizedを返すこと" do
        item.tier_rank_id = rank_id_with_order_zero
        item.tier_category_id = category_id_with_order_zero
        expect(item.generate_rank_category_key(rank_id_with_order_zero, category_id_with_order_zero)).to eq("unranked_uncategorized")
      end
    end

    context "tier_rank_idとtier_category_idがorderが0のものと一致しない場合" do
      it "tier_rank_idとtier_category_idをアンダースコアで連結した文字列を返すこと" do
        expect(item.generate_rank_category_key(rank_id_with_order_zero, category_id_with_order_zero)).to eq("#{item.tier_rank_id}_#{item.tier_category_id}")
      end
    end
  end

  describe "#image_data" do
    let(:item) { create(:item) }
    let(:variant_url) { "http://example.com/image.jpg" }

    subject { item.image_data(variant_url) }

    it "与えられたvariant_urlを含むハッシュを返すこと" do
      expect(subject).to eq({ url: variant_url, id: item.id })
    end
  end

  describe "コールバック" do
    context "Itemが破壊されたとき" do
      let(:item) { create(:item) }

      before do
        item.image.attach(io: File.open('spec/fixtures/Aldous.png'), filename: 'Aldous.png', content_type: 'image/jpeg')
      end

      it "画像がアタッチされていれば、画像がpurgeされること" do
        expect do
          item.destroy
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end
    end
  end
end
