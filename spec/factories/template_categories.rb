FactoryBot.define do
  factory :template_category do
    association :template
    name { "MyString" }
    order { 1 }
  end
end
