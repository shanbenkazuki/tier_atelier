require 'rails_helper'

RSpec.describe "Tiers", type: :system do
  include FillInSupport
  include TestHelpers
  let!(:category) { create(:category, name: "食事") }
  let!(:other_user_template) { create(:template, :with_images, :with_template_ranks, :with_template_categories, category:) }
  let(:other_user_tier) { create(:tier, category:) }
  let(:tier_by_unauthenticated_user) { create(:tier, :with_tier_ranks, :with_tier_categories, :with_images, :tier_by_unauthenticated_user) }

  context "tierの新規作成" do
    scenario "テンプレートからtierを作成できる", js: true do
      visit root_path
      click_link('作りに行く')
      expect(page).to have_current_path(templates_path)
      expect(page).to have_selector("img[src$='test_cover_image.png']")
      click_link('サンプルテンプレート')
      expect(current_path).to eq template_path(other_user_template)
      # テンプレートの編集と削除ボタンが表示されていないことを確認
      expect(page).to have_no_selector('#edit-template')
      expect(page).to have_no_selector('#delete-template')
      click_link('このテンプレートを使う')
      page.accept_confirm
      expect(page).to have_selector('.toast-body', text: 'テンプレート作成に成功しました')
      expect(page).to have_selector("img[src$='Uranus.png']")
      expect(page).to have_selector("img[src$='Eudora.png']")
      expect(page).to have_selector("img[src$='Estes.png']")
      expect(page).to have_current_path(arrange_tier_path(Tier.last))
    end

    scenario "tierを保存できない", js: true do
      visit arrange_tier_path(tier_by_unauthenticated_user)
      # tierの編集と削除ボタンが表示されていないことを確認
      expect(page).to have_no_selector('#edit-tier')
      expect(page).to have_no_selector('#delete-tier')
      # # tierの画像追加アイコンと削除アイコンが表示されていないことを確認
      expect(page).to have_no_selector('#add-image')
      expect(page).to have_no_selector('#trash-can')
      # 保存ボタン
      find('#display-modal').click
      # モーダルが表示されていることを確認
      expect(page).to have_selector('#save-image-modal')
      # テンプレートにするボタンが表示されていないことを確認
      expect(page).to have_no_selector('#make-template')
      find('#save-tier-image').click
      # ログイン画面に遷移してログインしてくださいというメッセージが表示されていることを確認
      expect(page).to have_selector('.toast-body', text: 'ログインしてください')
      expect(page).to have_current_path(login_path)
    end

    scenario "tierを画像として保存できる", js: true do
      visit arrange_tier_path(tier_by_unauthenticated_user)
      # 保存ボタン
      find('#display-modal').click
      # モーダルが表示されていることを確認
      expect(page).to have_selector('#save-image-modal')
      find('#tier-download').click
    end
  end

  context "tierの一覧表示" do
    scenario "tierの一覧画面に遷移できる" do
      visit root_path
      # Tierを見に行くリンクをクリック
      click_link 'Tierを見に行く'
      expect(page).to have_current_path(tiers_path)
    end

    scenario "tierのカテゴリ検索ができる", js: true, focus: true do
      # カテゴリを追加で2つ作成
      music_category = create(:category, name: "音楽")
      game_category = create(:category, name: "ゲーム")

      # カテゴリに属したtierを作成
      create(:tier, category:, title: "食事のTier")
      create(:tier, category: music_category, title: "音楽のTier")
      create(:tier, category: game_category, title: "ゲームのTier")
      visit tiers_path
      # カテゴリのセレクトボックスにカテゴリが表示されていることを確認
      expect(page).to have_selector('option', text: '食事')
      expect(page).to have_selector('option', text: '音楽')
      expect(page).to have_selector('option', text: 'ゲーム')

      # category_idのセレクトボックスの食事のカテゴリを選択
      select '食事', from: 'category_id'

      # 絞り込むボタンをクリック
      click_button '絞り込む'

      # 食事のTierが表示されていることを確認
      expect(page).to have_content('食事のTier')
      # 音楽のTierが表示されていないことを確認
      expect(page).not_to have_content('音楽のTier')
      # ゲームのTierが表示されていないことを確認
      expect(page).not_to have_content('ゲームのTier')
    end
  end
end
