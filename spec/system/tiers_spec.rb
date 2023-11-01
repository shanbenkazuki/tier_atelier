require 'rails_helper'

RSpec.describe "Tiers", type: :system do
  let(:user) { create(:user) }

  describe "ログイン前" do
    context "アクセス制限" do
      it "新規ページにアクセスするとエラーとなる" do
        visit new_tier_path
        expect(page).to have_content('ログインしてください')
        expect(current_path).to eq login_path
      end

      it "編集ページにアクセスするとエラーとなる" do
        tier = create(:tier)
        visit edit_tier_path(tier)
        expect(page).to have_content('ログインしてください')
        expect(current_path).to eq login_path
      end

      it "詳細ページにアクセスするとエラーとなる" do
        tier = create(:tier)
        visit tier_path(tier)
        expect(page).to have_content('ログインしてください')
        expect(current_path).to eq login_path
      end
    end
  end

  describe "ログイン後" do
    let!(:categories) { create_list(:category, 5) }

    before do
      login_as(user)
    end

    describe "新規登録" do
      before do
        visit new_tier_path
        select "フード", from: "tier_category_id"
      end

      context "正常系" do
        context "カテゴリとランクが10フィールドの場合" do
          it "tierの新規登録が成功する", js: true, focus: true do
            check_rank_and_category_remove_button
            extend_category_rank_fields_from_5_to_10

            fill_form(
              title: "新規テストタイトル",
              description: "新規テストの説明",
              ranks: ["unranked", "S", "A", "B", "C", "D", "E", "F", "G", "H", "I"],
              categories: ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid", "Balance", "Speeder", "Defender", "Supporter", "Attacker"]
            )

            attach_tier_images

            click_button "作成"

            expect(page).to have_selector('.alert.alert-success', text: 'Tier作成に成功しました')
            check_labels(
              expected_category_labels: ["Jungle", "Roam", "Exp", "Gold", "Mid", "Balance", "Speeder", "Defender", "Supporter", "Attacker"],
              expected_rank_labels: ["S", "A", "B", "C", "D", "E", "F", "G", "H", "I"]
            )
          end

          def check_rank_and_category_remove_button
            find('#add-ranks').click
            find('#remove-ranks').click
            find('#add-categories').click
            find('#remove-categories').click
          end

          def extend_category_rank_fields_from_5_to_10
            5.times { find('#add-ranks').click }
            5.times { find('#add-categories').click }
          end

          def attach_tier_images
            tier_image_names = ["Arlot", "Aldous", "Aulus"]
            tier_image_paths = tier_image_names.map do |name|
              Rails.root.join('spec', 'fixtures', "#{name}.png")
            end
            attach_file('tier[images][]', tier_image_paths, make_visible: true)
          end
        end
      end

      context "異常系" do
        it "タイトルが空白の場合、新規登録が失敗する" do
          fill_form(
            title: "",
            description: "新規テストの説明",
            ranks: ["unranked", "S", "A", "B", "C", "D"],
            categories: ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"]
          )

          click_button "作成"

          expect(page).to have_selector('.alert.alert-danger', text: 'Tier作成に失敗しました')
          expect(current_path).to eq tiers_path

          expect(page).to have_field('説明', with: '新規テストの説明')
          selected_option = find('#tier_category_id option[selected]').text
          expect(selected_option).to eq('フード')

          ranks = ["unranked", "S", "A", "B", "C", "D"]
          categories = ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"]

          check_rank_fields((1..5), ranks)
          check_category_fields((1..5), categories)
        end

        context "ランクに関するエラー" do
          it "ランクに1つでも空白がある場合、新規登録が失敗する" do
            fill_form(
              title: "新規テストタイトル",
              description: "新規テストの説明",
              ranks: ["unranked", "", "A", "B", "C", "D"],
              categories: ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"]
            )

            click_button "作成"

            expect(page).to have_selector('.alert.alert-danger', text: 'Tier作成に失敗しました')
            expect(current_path).to eq tiers_path

            expect(page).to have_field('説明', with: '新規テストの説明')
            selected_option = find('#tier_category_id option[selected]').text
            expect(selected_option).to eq('フード')

            ranks = ["unranked", "", "A", "B", "C", "D"]
            categories = ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"]

            check_rank_fields((1..5), ranks)
            check_category_fields((1..5), categories)
          end

          it "ランクを追加して新規登録が失敗する", js: true do
            multi_click('#add-ranks', 2)

            fill_form(
              title: "新規テストタイトル",
              description: "新規テストの説明",
              ranks: ["unranked", "S", "A", "B", "C", "D", "", "F"],
              categories: ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"]
            )

            scroll_and_submit_form("作成")

            expect(page).to have_selector('.alert.alert-danger', text: 'Tier作成に失敗しました')
            expect(current_path).to eq new_tier_path

            expect(page).to have_field('説明', with: '新規テストの説明')
            selected_option = find('#tier_category_id option[selected]').text
            expect(selected_option).to eq('フード')

            ranks = ["unranked", "S", "A", "B", "C", "D", "", "F"]
            categories = ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"]

            check_rank_fields((1..7), ranks)
            check_category_fields((1..5), categories)
          end
        end

        context "カテゴリに関するエラー" do
          it "カテゴリに1つでも空白がある場合、新規登録が失敗する" do
            fill_form(
              title: "新規テストタイトル",
              description: "新規テストの説明",
              ranks: ["unranked", "S", "A", "B", "C", "D"],
              categories: ["uncategorized", "", "Roam", "Exp", "Gold", "Mid"]
            )

            click_button "作成"

            expect(page).to have_selector('.alert.alert-danger', text: 'Tier作成に失敗しました')
            expect(current_path).to eq tiers_path

            expect(page).to have_field('説明', with: '新規テストの説明')
            selected_option = find('#tier_category_id option[selected]').text
            expect(selected_option).to eq('フード')

            ranks = ["unranked", "S", "A", "B", "C", "D"]
            categories = ["uncategorized", "", "Roam", "Exp", "Gold", "Mid"]

            check_rank_fields((1..5), ranks)
            check_category_fields((1..5), categories)
          end

          it "カテゴリを追加して新規登録が失敗する", js: true do
            scroll_to(find('#add-categories'))
            multi_click('#add-categories', 2)

            fill_form(
              title: "新規テストタイトル",
              description: "新規テストの説明",
              ranks: ["unranked", "S", "A", "B", "C", "D"],
              categories: ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "", "Balance", "Speeder"]
            )

            scroll_and_submit_form("作成")

            expect(page).to have_selector('.alert.alert-danger', text: 'Tier作成に失敗しました')
            expect(current_path).to eq new_tier_path

            expect(page).to have_field('説明', with: '新規テストの説明')
            selected_option = find('#tier_category_id option[selected]').text
            expect(selected_option).to eq('フード')

            ranks = ["unranked", "S", "A", "B", "C", "D"]
            categories = ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "", "Balance", "Speeder"]

            check_rank_fields((1..5), ranks)
            check_category_fields((1..7), categories)
          end
        end
      end
    end

    describe "詳細表示" do
      # ...
    end

    describe "編集・更新" do
      let(:tier) { create(:tier, :with_tier_ranks, :with_tier_categories, :with_images, user:, category: categories[0]) }

      before do
        visit arrange_tier_path(tier)
        click_link '編集'
        select "スポーツ", from: "tier_category_id"
      end

      context "正常系" do
        it "tierの更新が成功する", js: true do
          multi_click('#add-ranks', 2)
          scroll_to(find('#add-categories'))
          multi_click('#add-categories', 2)

          fill_form(
            title: "更新テストタイトル",
            description: "更新テストの説明",
            ranks: ["unranked", "E", "F", "G", "H", "I", "J", "K"],
            categories: ["uncategorized", "Balance", "Speeder", "Defender", "Supporter", "Attacker", "Fighter", "Mage"]
          )

          tier_image_names = ["Arlot", "Aldous", "Aulus"]
          tier_image_paths = tier_image_names.map do |name|
            Rails.root.join('spec', 'fixtures', "#{name}.png")
          end
          attach_file('tier[images][]', tier_image_paths, make_visible: true)

          scroll_and_submit_form("更新")

          expect(page).to have_selector('.alert.alert-success', text: 'Tier更新に成功しました')
          expect(current_path).to eq arrange_tier_path(tier)
          check_labels(
            expected_category_labels: ["Balance", "Speeder", "Defender", "Supporter", "Attacker", "Fighter", "Mage"],
            expected_rank_labels: ["E", "F", "G", "H", "I", "J", "K"]
          )
        end
      end

      context "異常系" do
        it "タイトルが空白の場合、更新が失敗する" do
          fill_form(
            title: "",
            description: "更新テストの説明",
            ranks: ["unranked", "E", "F", "G", "H", "I"],
            categories: ["uncategorized", "Balance", "Speeder", "Defender", "Supporter", "Attacker"]
          )

          click_button "更新"

          expect(page).to have_selector('.alert.alert-danger', text: 'Tier更新に失敗しました')
          expect(current_path).to eq tier_path(tier)

          expect(page).to have_field('説明', with: '更新テストの説明')
          selected_option = find('#tier_category_id option[selected]').text
          expect(selected_option).to eq('スポーツ')

          ranks = ["unranked", "E", "F", "G", "H", "I"]
          categories = ["uncategorized", "Balance", "Speeder", "Defender", "Supporter", "Attacker"]

          check_rank_fields((1..5), ranks)
          check_category_fields((1..5), categories)
        end

        context "カテゴリに関するエラー" do
          it "カテゴリに1つでも空白がある場合、更新が失敗する" do
            fill_form(
              title: "更新テストタイトル",
              description: "更新テストの説明",
              ranks: ["unranked", "E", "F", "G", "", "I"],
              categories: ["uncategorized", "Balance", "Speeder", "Defender", "Supporter", "Attacker"]
            )

            click_button "更新"

            expect(page).to have_selector('.alert.alert-danger', text: 'Tier更新に失敗しました')
            expect(current_path).to eq tier_path(tier)

            expect(page).to have_field('説明', with: '更新テストの説明')
            selected_option = find('#tier_category_id option[selected]').text
            expect(selected_option).to eq('スポーツ')

            ranks = ["unranked", "E", "F", "G", "", "I"]
            categories = ["uncategorized", "Balance", "Speeder", "Defender", "Supporter", "Attacker"]

            check_rank_fields((1..5), ranks)
            check_category_fields((1..5), categories)
          end
        end

        context "ランクに関するエラー" do
          it "ランクに1つでも空白がある場合、更新が失敗する" do
            fill_form(
              title: "更新テストタイトル",
              description: "更新テストの説明",
              ranks: ["unranked", "E", "F", "G", "H", "I"],
              categories: ["uncategorized", "Balance", "Speeder", "Defender", "", "Attacker"]
            )

            click_button "更新"

            expect(page).to have_selector('.alert.alert-danger', text: 'Tier更新に失敗しました')
            expect(current_path).to eq tier_path(tier)

            expect(page).to have_field('説明', with: '更新テストの説明')
            selected_option = find('#tier_category_id option[selected]').text
            expect(selected_option).to eq('スポーツ')

            ranks = ["unranked", "E", "F", "G", "H", "I"]

            check_rank_fields((1..5), ranks)
          end
        end
      end
    end

    describe "削除" do
      let(:tier) { create(:tier, :with_tier_ranks, :with_tier_categories, :with_images, user:, category: categories[0]) }

      context "正常系" do
        it "arrange画面からtierの削除が成功する", js: true do
          visit arrange_tier_path(tier)
          accept_confirm do
            click_link '削除'
          end
          expect(page).to have_selector('.alert.alert-success', text: 'Tierを削除しました')
        end

        it "詳細画面からtierの削除が成功する", js: true do
          visit tier_path(tier)
          accept_confirm do
            click_link '削除'
          end
          expect(page).to have_selector('.alert.alert-success', text: 'Tierを削除しました')
        end
      end
    end

    describe "配置" do
      let(:tier) { create(:tier, :with_tier_ranks, :with_tier_categories, :with_images, user:, category: categories[0]) }

      context "正常系" do
        it "画像をtierに配置できる", js: true do
          visit arrange_tier_path(tier)

          uranus_image = find("img[src*='Uranus.png']")
          eudora_image = find("img[src*='Eudora.png']")
          estes_image = find("img[src*='Estes.png']")

          tier_cell_4_1 = find("div[class='tier cell 4-1']")
          tier_cell_3_3 = find("div[class='tier cell 3-3']")
          tier_cell_1_4 = find("div[class='tier cell 1-4']")

          default_area = find("#default-area")

          uranus_image.drag_to(tier_cell_4_1)
          expect(find("div[class='tier cell 4-1']")).to have_selector("img[src*='Uranus.png']")
          uranus_image.drag_to(default_area)
          expect(find("#default-area")).to have_selector("img[src*='Uranus.png']")
          eudora_image.drag_to(tier_cell_3_3)
          expect(find("div[class='tier cell 3-3']")).to have_selector("img[src*='Eudora.png']")
          estes_image.drag_to(tier_cell_1_4)
          expect(find("div[class='tier cell 1-4']")).to have_selector("img[src*='Estes.png']")
        end

        it "画像の削除ができる", js: true do
          visit arrange_tier_path(tier)

          uranus_image = find("img[src*='Uranus.png']")
          delete_image_area = find("#trash-can")

          uranus_image.drag_to(delete_image_area)

          expect(page).to have_no_selector("img[src*='Uranus.png']")
        end

        it "tierの画像をダウンロードできる", js: true do
          visit arrange_tier_path(tier)

          scroll_to(find('#display-modal'))
          click_button '保存'
          click_button 'ダウンロード'
        end
      end
    end
  end

  def fill_attributes(attribute_name, values, from, to)
    (from..to).each do |i|
      fill_in "tier_#{attribute_name}_attributes_#{i}_name", with: values[i % values.length]
    end
  end

  def multi_click(id, times)
    times.times { find(id).click }
  end

  def scroll_and_submit_form(button_value)
    element = find("input[type='submit'][value='#{button_value}']")
    scroll_to(element)
    click_button button_value
  end

  def fill_form(title:, description:, ranks:, categories:)
    fill_in "タイトル", with: title
    fill_in "説明", with: description
    fill_attributes('tier_ranks', ranks, 1, ranks.length - 1)
    fill_attributes('tier_categories', categories, 1, categories.length - 1)
  end

  def check_labels(expected_category_labels:, expected_rank_labels:)
    category_labels = all('.category-label').map(&:text)
    expect(category_labels).to eq(expected_category_labels)

    rank_labels = all('.label-holder .label').map(&:text)
    expect(rank_labels).to eq(expected_rank_labels)
  end

  def check_rank_fields(range, ranks)
    range.each do |i|
      expect(page).to have_field("tier_tier_ranks_attributes_#{i}_name", with: ranks[i % ranks.length])
    end
  end

  def check_category_fields(range, categories)
    range.each do |i|
      expect(page).to have_field("tier_tier_categories_attributes_#{i}_name", with: categories[i % categories.length])
    end
  end
end
