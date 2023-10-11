require 'rails_helper'

RSpec.describe "Tiers", type: :request do
  describe "GET /tiers/new" do
    let(:user) { create(:user) }

    before do
      post login_path, params: { email: user.email, password: 'password' }
      get new_tier_path
    end

    it "レスポンスが成功すること" do
      expect(response).to have_http_status(:ok)
    end
  end
end
