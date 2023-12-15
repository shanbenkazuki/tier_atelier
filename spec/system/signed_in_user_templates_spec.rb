require 'rails_helper'

RSpec.describe "Templates", type: :system do
  include FillInSupport

  let(:user) { create(:user) }
  let!(:category) { create(:category, name: "食事") }

  before do
    login_as(user)
  end

  context "templateの新規作成" do
    # TODO: js: trueを外すとエラーになる
    scenario "templateを作成できる", js: true do
      visit root_path
      click_link('作りに行く')
      # テンプレート一覧画面に遷移する
      expect(page).to have_current_path(templates_path)
      # 新たにテンプレートを作成する
      click_link 'テンプレートを新しく作る'
      # テンプレート作成画面に遷移する
      expect(page).to have_current_path(new_template_path)
      # カテゴリを選択する
      select '食事', from: 'template[category_id]'
      # テンプレートのタイトルを入力する
      fill_in 'template[title]', with: 'テストタイトル'
      fill_in 'template[description]', with: 'テスト説明文'
      # spec/fixtures/test_cover_image.pngをアップロードする
      attach_file 'template[template_cover_image]', Rails.root.join("spec/fixtures/test_cover_image.png").to_s

      # テンプレートのランクを追加する
      # click_button find('#add-rank-field')
      # テンプレートの追加ボタンを押す
      click_button 'add-rank-field'
      # テンプレートのランクを削除する
      click_button 'remove-rank-field'
      # click_button find('#remove-rank-field')
      # # テンプレートのカテゴリを追加する
      click_button 'add-category-field'
      # click_button find('#add-category-field')
      # # テンプレートのカテゴリを削除する
      click_button 'remove-category-field'
      # click_button find('#remove-category-field')
      # # テンプレートランクを追加する
      5.times { click_button 'add-rank-field' }
      # sleep 5
      10.times { click_button 'add-category-field' }

      # テンプレートのランクを入力する
      fill_template_form(
        title: 'テストタイトル',
        description: 'テスト説明文',
        ranks: ['unranked', 'S', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'],
        categories: ['uncategorized', 'Category1', 'Category2', 'Category3', 'Category4', 'Category5', 'Category6', 'Category7', 'Category8', 'Category9', 'Category10']
      )

      # 登録する
      click_button '登録する'

      # テンプレート詳細画面に遷移する
      expect(page).to have_selector('.toast-body', text: 'テンプレート作成に成功しました')
      expect(page).to have_current_path(template_path(Template.last))
      # テンプレートのタイトルが表示されている
      expect(page).to have_content('テストタイトル')
      expect(page).to have_content('テスト説明文')
      # 入力したランクとカテゴリが表示されている
      check_labels(
        expected_category_labels: ['Category1', 'Category2', 'Category3', 'Category4', 'Category5', 'Category6', 'Category7', 'Category8', 'Category9', 'Category10'],
        expected_rank_labels: ['S', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I']
      )
    end
  end
end
