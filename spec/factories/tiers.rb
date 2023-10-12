FactoryBot.define do
  factory :tier do
    association :user
    title { "テストタイトル" }
    description { "テストの説明" }
    association :category

    after(:create) do |tier|
      ["unranked", "S", "A", "B", "C", "D"].each_with_index do |name, index|
        FactoryBot.create(:tier_rank, tier:, name:, order: index)
      end

      ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"].each_with_index do |name, index|
        FactoryBot.create(:tier_category, tier:, name:, order: index)
      end

      tier.cover_image.attach(
        io: Rails.root.join("spec/fixtures/test_cover_image.png").open,
        filename: 'test_cover_image.png',
        content_type: 'image/png'
      )

      ['ウラノス.png', 'エウドラ.png', 'エスタス.png'].each_with_index do |filename, index|
        tier_rank = tier.tier_ranks[index % tier.tier_ranks.size]  # Cycle through tier ranks
        tier_category = tier.tier_categories[index % tier.tier_categories.size]  # Cycle through tier categories

        item = FactoryBot.create(:item, tier:, tier_rank:, tier_category:)
        item.image.attach(
          io: Rails.root.join('spec', 'fixtures', filename).open,
          filename:,
          content_type: 'image/png'
        )
      end
    end
  end
end
