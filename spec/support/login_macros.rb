module LoginMacros
  def login_as(user)
    visit root_path
    find('#login', text: 'ログイン').click
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content "ログインに成功しました"
  end
end
