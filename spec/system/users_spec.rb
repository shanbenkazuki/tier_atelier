require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit new_user_path
          fill_in 'ユーザ名', with: 'hogehoge'
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録が完了しました'
          expect(page).to have_current_path(login_path)
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'ユーザ名', with: 'hogehoge'
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(current_path).to eq new_user_path
        end
      end

      context 'パスワードが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'ユーザ名', with: 'hogehoge'
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: ''
          fill_in 'パスワード確認', with: ''
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(current_path).to eq new_user_path
        end
      end

      context 'パスワードとパスワード確認が一致しない' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'ユーザ名', with: 'hogehoge'
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'mismatch'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(current_path).to eq new_user_path
        end
      end

      context 'メールアドレスが既に登録されている' do
        let!(:existing_user) { create(:user, email: 'email@example.com') }
      
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'ユーザ名', with: 'hogehoge'
          fill_in 'メールアドレス', with: existing_user.email
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(current_path).to eq new_user_path
        end
      end

    end
  end
end
