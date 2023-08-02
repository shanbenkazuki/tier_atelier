categories = ['エンタメ', 'ゲーム', 'フード', 'スポーツ', '教育']

categories.each do |category_name|
  Category.create(name: category_name)
end