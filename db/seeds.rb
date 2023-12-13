categories = [
  "ゲーム",
  "音楽",
  "スポーツ",
  "映像",
  "読書",
  "旅行",
  "アート",
  "科学",
  "自然",
  "ファッション",
  "政治",
  "健康"
]

categories.each do |category_name|
  Category.create(name: category_name)
end