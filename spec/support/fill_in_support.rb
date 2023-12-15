module FillInSupport
  def fill_tier_form(title:, description:, ranks:, categories:)
    fill_in "タイトル", with: title
    fill_in "説明", with: description
    fill_tier_attributes('tier_ranks', ranks, 1, ranks.length - 1)
    fill_tier_attributes('tier_categories', categories, 1, categories.length - 1)
  end

  def check_tier_labels(expected_category_labels:, expected_rank_labels:)
    category_labels = all('.category-label').map(&:text)
    expect(category_labels).to eq(expected_category_labels)

    rank_labels = all('.label-holder .label').map(&:text)
    expect(rank_labels).to eq(expected_rank_labels)
  end

  def fill_template_form(title:, description:, ranks:, categories:)
    fill_in "タイトル", with: title
    fill_in "説明", with: description
    fill_template_attributes('template_ranks', ranks, 1, ranks.length - 1)
    fill_template_attributes('template_categories', categories, 1, categories.length - 1)
  end

  def check_labels(expected_category_labels:, expected_rank_labels:)
    category_labels = all('.category-label').map(&:text)
    expect(category_labels).to eq(expected_category_labels)

    rank_labels = all('.label-holder .label').map(&:text)
    expect(rank_labels).to eq(expected_rank_labels)
  end

  private

  def fill_tier_attributes(attribute_name, values, from, to)
    (from..to).each do |i|
      fill_in "tier_#{attribute_name}_attributes_#{i}_name", with: values[i % values.length]
    end
  end

  def fill_template_attributes(attribute_name, values, from, to)
    (from..to).each do |i|
      fill_in "template_#{attribute_name}_attributes_#{i}_name", with: values[i % values.length]
    end
  end
end
