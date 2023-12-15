require 'rails_helper'

RSpec.describe "Tiers", type: :system do
  include FillInSupport
  include TestHelpers
  let!(:category) { create(:category, name: "食事") }
  let!(:other_user_template) { create(:template, :with_images, :with_template_ranks, :with_template_categories, category:) }
  let(:other_user_tier) { create(:tier, category:) }

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
      expect(page).to have_current_path(arrange_tier_path(Tier.last))
    end
  end
end
