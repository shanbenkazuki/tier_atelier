require 'rails_helper'

RSpec.describe "Tiers", type: :system do
  include FillInSupport

  let(:user) { create(:user) }
  let(:tier_by_unauthenticated_user) { create(:tier, :tier_by_unauthenticated_user) }
  let(:category_names) { ["アクション", "インディーズ", "アドベンチャー"] }

  # before do
  #   categories = [
  #     "アクション",
  #     "インディーズ",
  #     "アドベンチャー",
  #     "RPG",
  #     "ストラテジー",
  #     "シューティング",
  #     "カジュアル",
  #     "シミュレーション",
  #     "パズル",
  #     "アーケード",
  #     "プラットフォーマー",
  #     "大規模マルチプレイヤー",
  #     "レーシング",
  #     "スポーツ",
  #     "格闘",
  #     "ファミリー",
  #     "ボードゲーム",
  #     "教育",
  #     "カード",
  #     "ポイントアンドクリック",
  #     "音楽",
  #     "RTS",
  #     "TBS",
  #     "タクティカル",
  #     "クイズ",
  #     "ハクスラ",
  #     "ピンボール",
  #     "ビジュアルノベル",
  #     "カード＆ボード",
  #     "MOBA",
  #     "その他"
  #   ]
  #   categories.each do |category_name|
  #     create(:category, name: category_name)
  #   end
  # end

  context "tierの一覧表示" do
    before do
      visit tiers_path
    end

    scenario "tierの一覧画面に遷移できる" do
      expect(current_path).to eq tiers_path
    end

    scenario "登録したカテゴリが選択できる" do
      ["アクション", "インディーズ", "アドベンチャー"].each do |category_name|
        create(:category, name: category_name)
      end

      visit current_path

      select_box = find('select#category_id')
      ["アクション", "インディーズ", "アドベンチャー"].each do |category_name|
        expect(select_box).to have_selector('option', text: category_name)
      end
    end

    scenario "カテゴリを選択するとそのカテゴリに属したtierが表示される" do
      ["アクション", "インディーズ", "アドベンチャー"].each do |category_name|
        category = Category.find_or_create_by(name: category_name)
        create(:tier, category:, title: "#{category_name}のTier")
      end

      visit current_path

      expect(page).to have_content("アクションのTier")
      expect(page).to have_content("インディーズのTier")
      expect(page).to have_content("アドベンチャーのTier")

      select "アクション", from: "category_id"
      click_button "絞り込む"

      expect(page).to have_content("アクションのTier")
      expect(page).not_to have_content("インディーズのTier")
      expect(page).not_to have_content("アドベンチャーのTier")
    end
  end

  # context "ページアクセス" do
  #   scenario "一覧画面にアクセスできる" do
  #     visit tiers_path
  #     expect(current_path).to eq tiers_path
  #   end
  #   scenario "新規作成画面にアクセスできる" do
  #     visit new_tier_path
  #     expect(current_path).to eq new_tier_path
  #   end
  #   scenario "詳細画面にアクセスできる" do
  #     visit tier_path(tier)
  #     expect(current_path).to eq tier_path(tier)
  #   end

  #   scenario "配置画面にアクセスできる" do
  #     visit arrange_tier_path(tier)
  #     expect(current_path).to eq arrange_tier_path(tier)
  #   end

  #   scenario "編集画面にアクセスできない" do
  #     visit edit_tier_path(tier)
  #     expect(page).to have_content('ログインしてください')
  #     expect(current_path).to eq login_path
  #   end
  # end

  # context "tierの新規登録" do
  #   scenario "tierの新規登録が成功する" do
  #     visit new_tier_path
  #     select "アクション", from: "tier_category_id"
  #     fill_tier_form(
  #       title: "新規テストタイトル",
  #       description: "新規テストの説明",
  #       ranks: ["unranked", "S", "A", "B", "C", "D"],
  #       categories: ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"]
  #     )

  #     click_button "作成"

  #     expect(page).to have_selector('.alert.alert-success', text: 'Tier作成に成功しました')
  #     check_tier_labels(
  #       expected_category_labels: ["Jungle", "Roam", "Exp", "Gold", "Mid"],
  #       expected_rank_labels: ["S", "A", "B", "C", "D"]
  #     )
  #   end
  # end

  # context "tierの詳細表示" do
  #   scenario "tierの詳細表示が成功する" do
  #     visit tier_path(tier_by_unauthenticated_user)
  #     expect(page).to have_content tier_by_unauthenticated_user.title
  #     expect(page).to have_content tier_by_unauthenticated_user.description
  #   end
  # end

  # context "tierの更新" do
  #   scenario "tierの更新が失敗する" do
  #     visit edit_tier_path(tier_by_unauthenticated_user)
  #     expect(page).to have_content('ログインしてください')
  #     expect(current_path).to eq login_path
  #   end
  # end

  # context "正常系" do
  #   it "一覧画面にアクセスできる" do
  #     visit tiers_path
  #     expect(current_path).to eq tiers_path
  #   end

  #   it "新規作成画面にアクセスできる" do
  #     visit new_tier_path
  #     expect(current_path).to eq new_tier_path
  #   end

  #   it "詳細画面にアクセスできる" do
  #     tier = create(:tier)
  #     visit tier_path(tier)
  #     expect(current_path).to eq tier_path(tier)
  #   end

  #   it "配置画面にアクセスできる" do
  #     tier = create(:tier)
  #     visit arrange_tier_path(tier)
  #     expect(current_path).to eq arrange_tier_path(tier)
  #   end

  #   it "tierの新規登録が成功する" do
  #     visit new_tier_path
  #     select "アクション", from: "tier_category_id"
  #     fill_form(
  #       title: "新規テストタイトル",
  #       description: "新規テストの説明",
  #       ranks: ["unranked", "S", "A", "B", "C", "D"],
  #       categories: ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"]
  #     )

  #     click_button "作成"

  #     expect(page).to have_selector('.alert.alert-success', text: 'Tier作成に成功しました')
  #     check_labels(
  #       expected_category_labels: ["Jungle", "Roam", "Exp", "Gold", "Mid"],
  #       expected_rank_labels: ["S", "A", "B", "C", "D"]
  #     )
  #   end
  # end

  # context "異常系" do
  #   it "編集ページにアクセスするとリダイレクトされる" do
  #     tier = create(:tier)
  #     visit edit_tier_path(tier)
  #     expect(page).to have_content('ログインしてください')
  #     expect(current_path).to eq login_path
  #   end
  # end
end
