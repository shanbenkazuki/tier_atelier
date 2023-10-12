FactoryBot.define do
  factory :tier_category, class: 'TierCategory' do
    association :tier
    name { "Category Name" }
    order { 1 }
  end
end
