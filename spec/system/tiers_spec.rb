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
  
      # it "編集ページにアクセスするとエラーとなる" do
      #   tier = create(:tier)  # あるTierを作成（必要に応じてFactoryBot等を使用）
      #   visit edit_tier_path(tier)  # 作成したTierの編集ページへアクセス
      #   expect(page).to have_content('ログインしてください')
      #   expect(current_path).to eq login_path
      # end
      
      # it "詳細ページにアクセスするとエラーとなる" do
      #   tier = create(:tier)  # あるTierを作成（必要に応じてFactoryBot等を使用）
      #   visit tier_path(tier)  # 作成したTierの詳細ページへアクセス
      #   expect(page).to have_content('ログインしてください')
      #   expect(current_path).to eq login_path
      # end
    end
  end

  describe "ログイン後" do
    let!(:categories) { create_list(:category, 5) }
    
    before do
      login_as(user)
    end
    
    describe "新規登録" do
      def fill_tier_rank(from, to)
        (from..to).each do |i|
          fill_in "tier_tier_ranks_attributes_#{i}_name", with: ["S", "A", "B", "C", "D"][i % 5]
        end
      end

      def fill_tier_rank_brank(from, to)
        (from..to).each do |i|
          fill_in "tier_tier_ranks_attributes_#{i}_name", with: ["", "A", "B", "C", "D"][i % 5]
        end
      end
      
      def fill_tier_category(from, to)
        (from..to).each do |i|
          fill_in "tier_tier_categories_attributes_#{i}_name", with: ["Jungle", "Roam", "Exp", "Gold", "Mid"][i % 5]
        end
      end

      def fill_tier_category_brank(from, to)
        (from..to).each do |i|
          fill_in "tier_tier_categories_attributes_#{i}_name", with: ["", "Roam", "Exp", "Gold", "Mid"][i % 5]
        end
      end
      
      def click_add_button(id, times)
        times.times { find(id).click }
      end
      
      def hide_footer_and_scroll_to(element)
        page.execute_script("document.querySelector('footer.fixed-bottom').style.display = 'none';")
        scroll_to(element)
      end

      def submit_form
        element = find('input[type="submit"][value="作成"]')
        hide_footer_and_scroll_to(element)
        click_button "作成"
      end

      context "正常系" do
        context "カテゴリとランクが5フィールドの場合" do
          it "tierの新規登録が成功する" do
            visit new_tier_path
            select "フード", from: "tier_category_id"
            fill_in "タイトル", with: "テストタイトル"
            fill_in "説明", with: "テストの説明"
            fill_tier_rank(1, 5)
            fill_tier_category(1, 5)
            submit_form
            expect(page).to have_selector('.alert.alert-success', text: 'Tier作成に成功しました')
          end
        end
        
        context "カテゴリとランクが10フィールドの場合" do
          it "tierの新規登録が成功する" do
            visit new_tier_path
            select "フード", from: "tier_category_id"
            fill_in "タイトル", with: "テストタイトル"
            fill_in "説明", with: "テストの説明"
            click_add_button('#add-rank', 5)
            fill_tier_rank(1, 10)
            hide_footer_and_scroll_to(find('#add-category'))
            click_add_button('#add-category', 5)
            fill_tier_category(1, 10)
            submit_form
            expect(page).to have_selector('.alert.alert-success', text: 'Tier作成に成功しました')
          end
        end
    
        context "カバー画像がある場合" do
          it "tierの新規登録が成功する" do
            visit new_tier_path
            select "フード", from: "tier_category_id"
            fill_in "タイトル", with: "テストタイトル"
            fill_in "説明", with: "テストの説明"
            fill_tier_rank(1, 5)
            fill_tier_category(1, 5)

            # 画像をアップロード
            image_path = Rails.root.join('spec', 'fixtures', 'test_cover_image.png')
            attach_file('tier[cover_image]', image_path)

            submit_form
            expect(page).to have_selector('.alert.alert-success', text: 'Tier作成に成功しました')
          end
        end
    
        context "Tier画像がある場合" do
          it "3枚でtierの新規登録が成功する" do
            visit new_tier_path
            select "フード", from: "tier_category_id"
            fill_in "タイトル", with: "テストタイトル"
            fill_in "説明", with: "テストの説明"
            fill_tier_rank(1, 5)
            fill_tier_category(1, 5)
        
            # 複数の画像をアップロード
            image_names = ["アーロット", "アウラド", "アウルス"]
            image_paths = image_names.map do |name|
              Rails.root.join('spec', 'fixtures', "#{name}.png")
            end
            attach_file('tier[images][]', image_paths, make_visible: true)
        
            submit_form
            expect(page).to have_selector('.alert.alert-success', text: 'Tier作成に成功しました')
          end
        end
      end
      
      context "異常系" do
        it "タイトルが空白の場合、新規登録が失敗する" do
          visit new_tier_path
          select "フード", from: "tier_category_id"
          fill_in "説明", with: "テストの説明"
          fill_tier_rank(1, 5)
          fill_tier_category(1, 5)
      
          submit_form
          expect(page).to have_selector('.alert.alert-danger', text: 'Tier作成に失敗しました')
          expect(current_path).to eq new_tier_path

          # 入力された値が維持されているかを確認
          expect(page).to have_field('説明', with: 'テストの説明')
          selected_option = find('#tier_category_id option[selected]').text
          expect(selected_option).to eq('フード')

          ranks = ["S", "A", "B", "C", "D"]
          categories = ["Jungle", "Roam", "Exp", "Gold", "Mid"]
          
          (1..5).each do |i|
            expect(page).to have_field("tier_tier_ranks_attributes_#{i}_name", with: ranks[i % 5])
            expect(page).to have_field("tier_tier_categories_attributes_#{i}_name", with: categories[i % 5])
          end
        end
    
        
        context "ランクに関するエラー" do
          it "ランクに1つでも空白がある場合、新規登録が失敗する" do
            visit new_tier_path
            select "フード", from: "tier_category_id"
            fill_in "タイトル", with: "テストタイトル"
            fill_in "説明", with: "テストの説明"
            fill_tier_rank_brank(1, 5)
            fill_tier_category(1, 5)
        
            submit_form
            expect(page).to have_selector('.alert.alert-danger', text: 'Tier作成に失敗しました')
            expect(current_path).to eq new_tier_path
  
            # 入力された値が維持されているかを確認
            expect(page).to have_field('タイトル', with: 'テストタイトル')
            expect(page).to have_field('説明', with: 'テストの説明')
            selected_option = find('#tier_category_id option[selected]').text
            expect(selected_option).to eq('フード')
  
            ranks = ["", "A", "B", "C", "D"]
            categories = ["Jungle", "Roam", "Exp", "Gold", "Mid"]
            
            (1..5).each do |i|
              expect(page).to have_field("tier_tier_ranks_attributes_#{i}_name", with: ranks[i % 5])
              expect(page).to have_field("tier_tier_categories_attributes_#{i}_name", with: categories[i % 5])
            end
          end
        end

        context "カテゴリに関するエラー" do
          it "カテゴリに1つでも空白がある場合、新規登録が失敗する" do
            visit new_tier_path
            select "フード", from: "tier_category_id"
            fill_in "タイトル", with: "テストタイトル"
            fill_in "説明", with: "テストの説明"
            fill_tier_rank(1, 5)
            fill_tier_category_brank(1, 5)
        
            submit_form
            expect(page).to have_selector('.alert.alert-danger', text: 'Tier作成に失敗しました')
            expect(current_path).to eq new_tier_path
  
            # 入力された値が維持されているかを確認
            expect(page).to have_field('タイトル', with: 'テストタイトル')
            expect(page).to have_field('説明', with: 'テストの説明')
            selected_option = find('#tier_category_id option[selected]').text
            expect(selected_option).to eq('フード')
  
            ranks = ["S", "A", "B", "C", "D"]
            categories = ["", "Roam", "Exp", "Gold", "Mid"]
            
            (1..5).each do |i|
              expect(page).to have_field("tier_tier_ranks_attributes_#{i}_name", with: ranks[i % 5])
              expect(page).to have_field("tier_tier_categories_attributes_#{i}_name", with: categories[i % 5])
            end
          end
        end
      end
    end

  #   describe "一覧表示" do
  #     # ...
  #   end

  #   describe "詳細表示" do
  #     # ...
  #   end

  #   describe "編集・更新" do
  #     context "正常系" do
  #       it "tierの更新が成功する" do
  #         # 基本的な更新のシナリオ
  #         # ...
  #       end
    
  #       context "カテゴリとランクが5フィールドの場合" do
  #         it "tierの更新が成功する" do
  #           # ...
  #         end
  #       end
    
  #       context "カテゴリとランクが10フィールドの場合" do
  #         it "tierの更新が成功する" do
  #           # ...
  #         end
  #       end
    
  #       context "カバー画像がある場合" do
  #         it "tierの更新が成功する" do
  #           # カバー画像を更新するシナリオ
  #           # ...
  #         end
  #       end
    
  #       context "Tier画像がある場合" do
  #         it "30枚でtierの更新が成功する" do
  #           # Tier画像を更新するシナリオ
  #           # ...
  #         end
  #       end
  #     end
    
  #     context "異常系" do
  #       it "tierの更新が失敗する" do
  #         # 一般的な更新失敗のシナリオ
  #         # ...
  #       end
    
  #       it "タイトルが空白の場合、更新が失敗する" do
  #         # タイトル空白に関するシナリオ
  #         # ...
  #       end
    
  #       context "カテゴリに関するエラー" do
  #         it "カテゴリに1つでも空白がある場合、更新が失敗する" do
  #           # カテゴリの空白に関するシナリオ
  #           # ...
  #         end
  #       end
    
  #       context "ランクに関するエラー" do
  #         it "ランクに1つでも空白がある場合、更新が失敗する" do
  #           # ランクの空白に関するシナリオ
  #           # ...
  #         end
  #       end
  #     end
  #   end

  #   describe "削除" do
  #     it "tierの削除が成功する" do
  #       # ...
  #     end
  #   end
  end
end
