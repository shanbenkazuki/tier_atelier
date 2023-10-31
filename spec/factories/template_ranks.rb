FactoryBot.define do
  factory :template_rank do
    association :template
    name { "MyString" }
    order { 1 }
  end
end
