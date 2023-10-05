FactoryBot.define do
  factory :category do
    sequence(:name) do |n|
      case n
      when 1 then "エンタメ"
      when 2 then "ゲーム"
      when 3 then "フード"
      when 4 then "スポーツ"
      when 5 then "教育"
      else "カテゴリー#{n}"
      end
    end
  end
end