class RenameColumnsInItems < ActiveRecord::Migration[7.0]
  def change
    # 既存の外部キー制約を削除
    remove_foreign_key :items, column: :rank_id
    remove_foreign_key :items, column: :category_id
    
    # カラム名を変更
    rename_column :items, :rank_id, :tier_rank_id
    rename_column :items, :category_id, :tier_category_id

    # 新しいカラム名に外部キー制約を追加
    add_foreign_key :items, :tier_ranks, column: :tier_rank_id
    add_foreign_key :items, :tier_categories, column: :tier_category_id
  end
end
