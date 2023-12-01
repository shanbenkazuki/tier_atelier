FactoryBot.define do
  factory :category do
    genres = [
      "アクション", # Action
      "インディーズ", # Indie
      "アドベンチャー", # Adventure
      "ロールプレイングゲーム", # RPG (Role Playing Game)
      "ストラテジー", # Strategy
      "シューティング", # Shooter
      "カジュアル", # Casual
      "シミュレーション", # Simulation
      "パズル", # Puzzle
      "アーケード", # Arcade
      "プラットフォーマー", # Platformer
      "大規模マルチプレイヤー", # Massively Multiplayer
      "レーシング", # Racing
      "スポーツ", # Sports
      "格闘", # Fighting
      "ファミリー", # Family
      "ボードゲーム", # Board Games
      "教育", # Educational
      "カード", # Card
      "ポイントアンドクリック", # Point-and-click
      "音楽", # Music
      "リアルタイムストラテジー（RTS）",  # Real Time Strategy (RTS)
      "ターンベースストラテジー（TBS）",  # Turn-based strategy (TBS)
      "タクティカル", # Tactical
      "クイズ/トリビア", # Quiz/Trivia
      "ハックアンドスラッシュ/ビートエムアップ", # Hack and slash/Beat 'em up
      "ピンボール", # Pinball
      "ビジュアルノベル", # Visual Novel
      "カード＆ボードゲーム", # Card & Board Game
      "MOBA（マルチプレイヤーオンラインバトルアリーナ）",  # MOBA
      "その他"
    ]
    sequence(:name) { |n| genres[n % 30] }
  end
end
