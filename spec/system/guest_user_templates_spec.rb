require 'rails_helper'

RSpec.describe "Templates", type: :system do
  let!(:category) { create(:category, name: "食事") }
  let!(:other_user_template) { create(:template, :with_images, :with_template_ranks, :with_template_categories, category:) }

  context "templateの新規作成" do
    scenario "templateの作成ができない" do
      visit root_path
      click_link('作りに行く')
      # テンプレート一覧画面に遷移する
      expect(page).to have_current_path(templates_path)
      # テンプレートを新しく作るボタンが表示されていないことを確認
      expect(page).to have_no_selector('#new-template')
    end
  end

  context "templateの一覧表示" do
    scenario "templateの一覧表示ができる" do
      visit root_path
      click_link('作りに行く')
      # テンプレート一覧画面に遷移する
      expect(page).to have_current_path(templates_path)
      # テンプレート一覧画面にテンプレートが表示されていることを確認
      expect(page).to have_selector("img[src$='test_cover_image.png']")
    end

    scenario "templateのカテゴリ検索ができる" do
      music_category = create(:category, name: "音楽")
      game_category = create(:category, name: "ゲーム")

      create(:template, category:, title: "食事のTemplate")
      create(:template, category: music_category, title: "音楽のTemplate")
      create(:template, category: game_category, title: "ゲームのTemplate")
      visit templates_path
      # カテゴリのセレクトボックスにカテゴリが表示されていることを確認
      expect(page).to have_selector('option', text: '食事')
      expect(page).to have_selector('option', text: '音楽')
      expect(page).to have_selector('option', text: 'ゲーム')

      # category_idのセレクトボックスの食事のカテゴリを選択
      select '食事', from: 'category_id'

      # 絞り込むボタンをクリック
      click_button '絞り込む'

      # 食事のTemplateが表示されていることを確認
      expect(page).to have_content('食事のTemplate')
      # 音楽のTemplateが表示されていないことを確認
      expect(page).not_to have_content('音楽のTemplate')
      # ゲームのTemplateが表示されていないことを確認
      expect(page).not_to have_content('ゲームのTemplate')
    end
  end
end
