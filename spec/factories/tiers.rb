FactoryBot.define do
  factory :tier do
    association :user
    title { "テストタイトル" }
    description { "テストの説明" }
    association :category

    trait :with_tier_ranks do
      after(:create) do |tier|
        ["unranked", "S", "A", "B", "C", "D"].each_with_index do |name, index|
          FactoryBot.create(:tier_rank, tier: tier, name: name, order: index)
        end
      end
    end

    trait :with_tier_categories do
      after(:create) do |tier|
        ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"].each_with_index do |name, index|
          FactoryBot.create(:tier_category, tier: tier, name: name, order: index)
        end
      end
    end

    trait :with_images do
      after(:create) do |tier|
        tier.cover_image.attach(
          io: Rails.root.join("spec/fixtures/test_cover_image.png").open,
          filename: 'test_cover_image.png',
          content_type: 'image/png'
        )

        ['Uranus.png', 'Eudora.png', 'Estes.png'].each do |filename|
          tier_rank = tier.tier_ranks[0]
          tier_category = tier.tier_categories[0]

          item = FactoryBot.create(:item, tier: tier, tier_rank: tier_rank, tier_category: tier_category)
          item.image.attach(
            io: Rails.root.join('spec', 'fixtures', filename).open,
            filename:,
            content_type: 'image/png'
          )
        end
      end
    end
  end
end
