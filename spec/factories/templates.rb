FactoryBot.define do
  factory :template do
    association :user
    title { "サンプルテンプレート" }
    description { "テンプレートの詳細説明" }
    association :category
  end
end
