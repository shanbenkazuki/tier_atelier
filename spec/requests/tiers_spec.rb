require 'rails_helper'

RSpec.describe "Tiers", type: :request do
  describe "GET /tiers/new" do
    before do
      get new_tier_path
    end

    it "レスポンスが成功すること" do
      expect(response).to have_http_status(:ok)
    end

    # context "カテゴリー表示の確認" do
    #   let!(:categories) { create_list(:category, 5) }  # FactoryBotを使用して5つのカテゴリーを作成

    #   it "すべてのカテゴリーが正しく表示されること" do
    #     categories.each do |category|
    #       expect(response.body).to include(category.name)
    #     end
    #   end
    # end
  end
end
