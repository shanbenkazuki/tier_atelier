class CreateTiers < ActiveRecord::Migration[7.0]
  def change
    create_table :tiers do |t|
      t.references :tier_list, null: false, foreign_key: true
      t.string :horizontal_name, null: false
      t.string :vertical_name, null: false
      t.integer :horizontal_order
      t.integer :vertical_order

      t.timestamps
    end
  end
end
