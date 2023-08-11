class RenameTierListIdToTierId < ActiveRecord::Migration[7.0]
  def change
    rename_column :tier_categories, :tier_list_id, :tier_id
    rename_column :tier_ranks, :tier_list_id, :tier_id

    # 外部キー制約の削除と再追加
    remove_foreign_key :tier_categories, column: :tier_id
    remove_foreign_key :tier_ranks, column: :tier_id
    add_foreign_key :tier_categories, :tiers, column: :tier_id
    add_foreign_key :tier_ranks, :tiers, column: :tier_id
  end
end
