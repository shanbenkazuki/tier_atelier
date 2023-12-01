categories = [
  "アクション", 
  "インディーズ",  # Indie
  "アドベンチャー",  # Adventure
  "RPG",  # RPG (Role Playing Game)
  "ストラテジー",  # Strategy
  "シューティング",  # Shooter
  "カジュアル",  # Casual
  "シミュレーション",  # Simulation
  "パズル",  # Puzzle
  "アーケード",  # Arcade
  "プラットフォーマー",  # Platformer
  "大規模マルチプレイヤー",  # Massively Multiplayer
  "レーシング",  # Racing
  "スポーツ",  # Sports
  "格闘",  # Fighting
  "ファミリー",  # Family
  "ボードゲーム",  # Board Games
  "教育",  # Educational
  "カード",  # Card
  "ポイントアンドクリック",  # Point-and-click
  "音楽",  # Music
  "RTS",  # Real Time Strategy (RTS)
  "TBS",  # Turn-based strategy (TBS)
  "タクティカル",  # Tactical
  "クイズ",  # Quiz/Trivia
  "ハクスラ",  # Hack and slash/Beat 'em up
  "ピンボール",  # Pinball
  "ビジュアルノベル",  # Visual Novel
  "カード＆ボード",  # Card & Board Game
  "MOBA",  # MOBA
  "その他"
]

categories.each do |category_name|
  Category.create(name: category_name)
end