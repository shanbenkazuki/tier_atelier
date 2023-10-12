FactoryBot.define do
  factory :tier_rank, class: 'TierRank' do
    association :tier
    name { "Rank Name" }
    order { 1 }
  end
end
