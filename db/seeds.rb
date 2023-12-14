categories = [
  "アニメ",
  "音楽",
  "ゲーム",
  "スポーツ",
  "旅行",
  "食事",
  "ファッション",
  "書籍",
  "テクノロジー",
  "アート"
]

categories.each do |category_name|
  Category.create(name: category_name)
end
