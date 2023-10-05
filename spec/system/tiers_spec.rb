require 'rails_helper'

RSpec.describe "Tiers", type: :system do
  let(:user) { create(:user) }
  let!(:categories) { create_list(:category, 5) }

  describe "ログイン前" do

  end
  describe "ログイン後" do

  end
  describe "新しいTierの作成" do

    before do
      login_as(user)
    end
    
    describe "新規登録" do
      it "tierの新規登録が成功する" do
        visit new_tier_path
        select "フード", from: "tier_category_id"
        fill_in "タイトル", with: "テストタイトル"
        fill_in "説明", with: "テストの説明"
  
        fill_in "tier_rank_1", with: "S"
        fill_in "tier_rank_2", with: "A"
        fill_in "tier_rank_3", with: "B"
        fill_in "tier_rank_4", with: "C"
        fill_in "tier_rank_5", with: "D"
  
        fill_in "tier_category_1", with: "Jungle"
        fill_in "tier_category_2", with: "Roam"
        fill_in "tier_category_3", with: "Exp"
        fill_in "tier_category_4", with: "Gold"
        fill_in "tier_category_5", with: "Mid"
  
        element = find('input[type="submit"][value="作成"]')
        scroll_to(element)
        sleep 0.5
        click_button "作成"
        expect(page).to have_current_path("/tiers/#{Tier.last.id}/make")
        expect(page).to have_selector('.alert.alert-success', text: 'Tier作成に成功しました')
      end
    end
  end
end
