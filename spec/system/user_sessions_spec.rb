require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザーログイン' do
      before do
        visit login_path
      end

      context 'フォームの入力値が正常' do
        it 'ログインが成功する' do
          fill_in 'メールアドレス', with: user.email
          fill_in 'パスワード', with: 'password'
          click_button 'ログイン'
          expect(page).to have_content 'ログインに成功しました'
          expect(page).to have_current_path(root_path)
        end
      end

      context 'メールアドレスが未入力' do
        it 'ログインが失敗する' do
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: 'password'
          click_button 'ログイン'
          expect(page).to have_content 'ログインに失敗しました'
          expect(current_path).to eq login_path
        end
      end

      context 'パスワードが未入力' do
        it 'ログインが失敗する' do
          fill_in 'メールアドレス', with: user.email
          fill_in 'パスワード', with: ''
          click_button 'ログイン'
          expect(page).to have_content 'ログインに失敗しました'
          expect(current_path).to eq login_path
        end
      end

      context 'メールアドレスが無効' do
        it 'ログインが失敗する' do
          fill_in 'メールアドレス', with: 'invalid@example.com'
          fill_in 'パスワード', with: 'password'
          click_button 'ログイン'
          expect(page).to have_content 'ログインに失敗しました'
          expect(current_path).to eq login_path
        end
      end

      context 'パスワードが無効' do
        it 'ログインが失敗する' do
          fill_in 'メールアドレス', with: user.email
          fill_in 'パスワード', with: 'invalidpassword'
          click_button 'ログイン'
          expect(page).to have_content 'ログインに失敗しました'
          expect(current_path).to eq login_path
        end
      end
    end
  end
end
