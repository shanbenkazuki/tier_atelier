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

    def fill_attributes(attribute_name, values, from, to)
      (from..to).each do |i|
        fill_in "tier_#{attribute_name}_attributes_#{i}_name", with: values[i % values.length]
      end
    end

    def multi_click(id, times)
      times.times { find(id).click }
    end

    def hide_footer_and_scroll_to(element)
      page.execute_script("document.querySelector('footer.fixed-bottom').style.display = 'none';")
      scroll_to(element)
    end

    def scroll_and_submit_form(button_value)
      element = find("input[type='submit'][value='#{button_value}']")
      hide_footer_and_scroll_to(element)
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

    def fill_common_form_fields
      fill_form(
        title: "新規テストタイトル",
        description: "新規テストの説明",
        ranks: ["unranked", "S", "A", "B", "C", "D"],
        categories: ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"]
      )
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

    def delete_tier_from_path(path)
      visit path
      accept_confirm do
        click_link '削除'
      end
      expect(page).to have_selector('.alert.alert-success', text: 'Tierを削除しました')
    end

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
          it "tierの新規登録が成功する" do
            multi_click('#add-ranks', 1)
            multi_click('#remove-ranks', 1)
            multi_click('#add-ranks', 5)
            hide_footer_and_scroll_to(find('#add-categories'))
            multi_click('#add-categories', 1)
            multi_click('#remove-categories', 1)
            multi_click('#add-categories', 5)

            fill_form(
              title: "新規テストタイトル",
              description: "新規テストの説明",
              ranks: ["unranked", "S", "A", "B", "C", "D", "E", "F", "G", "H", "I"],
              categories: ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid", "Balance", "Speeder", "Defender", "Supporter", "Attacker"]
            )

            image_path = Rails.root.join("spec/fixtures/test_cover_image.png")
            attach_file('tier[cover_image]', image_path)

            tier_image_names = ["アーロット", "アウラド", "アウルス"]
            tier_image_paths = tier_image_names.map do |name|
              Rails.root.join('spec', 'fixtures', "#{name}.png")
            end
            attach_file('tier[images][]', tier_image_paths, make_visible: true)

            scroll_and_submit_form("作成")

            expect(page).to have_selector('.alert.alert-success', text: 'Tier作成に成功しました')
            check_labels(
              expected_category_labels: ["Jungle", "Roam", "Exp", "Gold", "Mid", "Balance", "Speeder", "Defender", "Supporter", "Attacker"],
              expected_rank_labels: ["S", "A", "B", "C", "D", "E", "F", "G", "H", "I"]
            )
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

          scroll_and_submit_form("作成")

          expect(page).to have_selector('.alert.alert-danger', text: 'Tier作成に失敗しました')
          expect(current_path).to eq new_tier_path

          # 入力された値が維持されているかを確認
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

            scroll_and_submit_form("作成")

            expect(page).to have_selector('.alert.alert-danger', text: 'Tier作成に失敗しました')
            expect(current_path).to eq new_tier_path

            # 入力された値が維持されているかを確認
            expect(page).to have_field('説明', with: '新規テストの説明')
            selected_option = find('#tier_category_id option[selected]').text
            expect(selected_option).to eq('フード')

            ranks = ["unranked", "", "A", "B", "C", "D"]
            categories = ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"]

            check_rank_fields((1..5), ranks)
            check_category_fields((1..5), categories)
          end

          it "ランクを追加して新規登録が失敗する" do
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

            # 入力された値が維持されているかを確認
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

            scroll_and_submit_form("作成")

            expect(page).to have_selector('.alert.alert-danger', text: 'Tier作成に失敗しました')
            expect(current_path).to eq new_tier_path

            # 入力された値が維持されているかを確認
            expect(page).to have_field('説明', with: '新規テストの説明')
            selected_option = find('#tier_category_id option[selected]').text
            expect(selected_option).to eq('フード')

            ranks = ["unranked", "S", "A", "B", "C", "D"]
            categories = ["uncategorized", "", "Roam", "Exp", "Gold", "Mid"]

            check_rank_fields((1..5), ranks)
            check_category_fields((1..5), categories)
          end

          it "カテゴリを追加して新規登録が失敗する" do
            hide_footer_and_scroll_to(find('#add-categories'))
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

            # 入力された値が維持されているかを確認
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
      let(:tier) { create(:tier, user:, category: categories[0]) }

      before do
        visit make_tier_path(tier)
        click_link '編集'
        select "スポーツ", from: "tier_category_id"
      end

      context "正常系" do
        it "tierの更新が成功する" do
          multi_click('#add-ranks', 2)
          hide_footer_and_scroll_to(find('#add-categories'))
          multi_click('#add-categories', 2)

          fill_form(
            title: "更新テストタイトル",
            description: "更新テストの説明",
            ranks: ["unranked", "E", "F", "G", "H", "I", "J", "K"],
            categories: ["uncategorized", "Balance", "Speeder", "Defender", "Supporter", "Attacker", "Fighter", "Mage"]
          )

          cover_image_path = Rails.root.join("spec/fixtures/update_cover_image.png")
          attach_file('tier[cover_image]', cover_image_path)

          tier_image_names = ["アーロット", "アウラド", "アウルス"]
          tier_image_paths = tier_image_names.map do |name|
            Rails.root.join('spec', 'fixtures', "#{name}.png")
          end
          attach_file('tier[images][]', tier_image_paths, make_visible: true)

          scroll_and_submit_form("更新")

          expect(page).to have_selector('.alert.alert-success', text: 'Tier更新に成功しました')
          expect(current_path).to eq make_tier_path(tier)
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

          scroll_and_submit_form("更新")

          expect(page).to have_selector('.alert.alert-danger', text: 'Tier更新に失敗しました')
          expect(current_path).to eq edit_tier_path(tier)

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

            scroll_and_submit_form("更新")

            expect(page).to have_selector('.alert.alert-danger', text: 'Tier更新に失敗しました')
            expect(current_path).to eq edit_tier_path(tier)

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

            scroll_and_submit_form("更新")

            expect(page).to have_selector('.alert.alert-danger', text: 'Tier更新に失敗しました')
            expect(current_path).to eq edit_tier_path(tier)

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
      let(:tier) { create(:tier, user:, category: categories[0]) }

      before do
        visit make_tier_path(tier)
      end

      context "正常系" do
        it "make画面からtierの削除が成功する" do
          delete_tier_from_path(make_tier_path(tier))
        end

        it "詳細画面からtierの削除が成功する" do
          delete_tier_from_path(tier_path(tier))
        end
      end
    end
  end
end
