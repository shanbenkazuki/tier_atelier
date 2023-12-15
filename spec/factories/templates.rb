FactoryBot.define do
  factory :template do
    association :user
    title { "サンプルテンプレート" }
    description { "テンプレートの詳細説明" }
    association :category

    trait :with_template_ranks do
      after(:create) do |template|
        ["unranked", "S", "A", "B", "C", "D"].each_with_index do |name, index|
          FactoryBot.create(:template_rank, template:, name:, order: index)
        end
      end
    end

    trait :with_template_categories do
      after(:create) do |template|
        ["uncategorized", "Jungle", "Roam", "Exp", "Gold", "Mid"].each_with_index do |name, index|
          FactoryBot.create(:template_category, template:, name:, order: index)
        end
      end
    end

    trait :with_images do
      after(:create) do |template|
        template.template_cover_image.attach(
          io: Rails.root.join("spec/fixtures/test_cover_image.png").open,
          filename: 'test_cover_image.png',
          content_type: 'image/png'
        )

        file_names = ['Uranus.png', 'Eudora.png', 'Estes.png']
        file_names.each do |file_name|
          path = Rails.root.join('spec', 'fixtures', file_name)
          file = File.open(path, 'rb')
          template.tier_images.attach(io: file, filename: file_name, content_type: 'image/png')
        end
      end
    end
  end
end
