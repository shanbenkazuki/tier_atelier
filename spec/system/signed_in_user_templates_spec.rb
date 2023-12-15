equire 'rails_helper'

RSpec.describe "Templates", type: :system do
  context "templateの新規作成" do
    scenario "templateを作成できる", js: true do
      visit root_path
      click_link('作りに行く')
    end
  end
end
