module TestHelpers
  def select_and_use_template
    visit root_path
    click_link('作りに行く')
    expect(page).to have_current_path(templates_path)
    expect(page).to have_selector("img[src$='test_cover_image.png']")
    click_link('サンプルテンプレート')
    expect(current_path).to eq template_path(other_user_template)
    click_link('このテンプレートを使う')
    page.accept_confirm
    expect(page).to have_selector('.toast-body', text: 'テンプレート作成に成功しました')
    expect(page).to have_selector("img[src$='Uranus.png']")
    expect(page).to have_selector("img[src$='Eudora.png']")
    expect(page).to have_selector("img[src$='Estes.png']")
    expect(current_path).to eq arrange_tier_path(Tier.last)
  end
end