FactoryBot.define do
  factory :item, class: 'Item' do
    association :tier
    association :tier_category
    association :tier_rank
  end
end
