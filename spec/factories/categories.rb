FactoryBot.define do
  factory :category do
    sequence(:name) { |n| ["エンタメ", "ゲーム", "フード", "スポーツ", "教育"][n % 5] }
  end
end