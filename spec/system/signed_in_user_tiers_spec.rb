require 'rails_helper'

RSpec.describe "Tiers", type: :system do
  include FillInSupport
  let(:user) { create(:user) }
  let!(:category) { create(:category, name: "食事") }
  let!(:other_user_template) { create(:template, :with_images, :with_template_ranks, :with_template_categories, category:) }
  let(:tier) { create(:tier, :with_tier_ranks, :with_tier_categories, :with_images, user:, category:) }

  before do
    login_as(user)
  end

  context "tierの新規作成" do
    scenario "テンプレートからtierを作成できる", js: true do
      visit root_path
      click_link('作りに行く')
      expect(page).to have_current_path(templates_path)
      expect(page).to have_selector("img[src$='test_cover_image.png']")
      click_link('サンプルテンプレート')
      expect(current_path).to eq template_path(other_user_template)
      click_link('このテンプレートを使う')
      page.accept_confirm
      expect(page).to have_selector('.toast-body', text: 'テンプレート作成に成功しました')
      expect(page).to have_selector("img[src$='Uranus.png']")
      expect(page).to have_selector("img[src$='Eudora.png']")
      expect(page).to have_selector("img[src$='Estes.png']")
      expect(current_path).to eq arrange_tier_path(Tier.last)
    end
  end

  # CSRF対処しないとエラーになるhttps://qiita.com/kazutosato/items/b60fc9905e1adb83d9a4
  context "tierの保存" do
    scenario "作成したtierを保存できる", js: true do
      visit arrange_tier_path(tier)
      uranus_image = find("img[src*='Uranus.png']")
      eudora_image = find("img[src*='Eudora.png']")
      estes_image = find("img[src*='Estes.png']")

      tier_cell_4_1 = find("div[class='tier cell 4-1']")
      tier_cell_3_3 = find("div[class='tier cell 3-3']")
      tier_cell_1_4 = find("div[class='tier cell 1-4']")

      default_area = find("#default-area")

      uranus_image.drag_to(tier_cell_4_1)
      uranus_image.drag_to(default_area)
      eudora_image.drag_to(tier_cell_3_3)
      estes_image.drag_to(tier_cell_1_4)
      find('#display-modal').click
      find('#save-tier-image').click
      expect(page).to have_current_path(tier_path(tier))
      expect(page).to have_content("テストタイトル")
      expect(find("div[class='tier cell 3-3']")).to have_selector("img[src*='Eudora.png']")
      expect(find("div[class='tier cell 1-4']")).to have_selector("img[src*='Estes.png']")
    end
  end
end
