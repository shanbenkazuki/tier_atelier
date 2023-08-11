class DropTiersTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :tiers
  end

  def down
    create_table "tiers", force: :cascade do |t|
      t.bigint "tier_list_id", null: false
      t.string "horizontal_name", null: false
      t.string "vertical_name", null: false
      t.integer "horizontal_order"
      t.integer "vertical_order"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["tier_list_id"], name: "index_tiers_on_tier_list_id"
    end
  end
end
