module LoginMacros
  def login_as(user)
    visit root_path
    find('.btn-primary.btn-lg', text: 'ログイン').click
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    sleep 0.5
  end
end
