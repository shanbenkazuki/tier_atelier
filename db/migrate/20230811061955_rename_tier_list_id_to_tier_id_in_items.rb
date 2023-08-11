class RenameTierListIdToTierIdInItems < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :tier_list_id, :tier_id

    # 外部キー制約の削除と再追加 (必要であれば)
    remove_foreign_key :items, column: :tier_id
    add_foreign_key :items, :tiers, column: :tier_id
  end
end
