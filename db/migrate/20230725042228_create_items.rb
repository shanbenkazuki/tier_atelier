class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :tier_list, null: false, foreign_key: true
      t.string :name, null: false
      t.string :image_url, null: false
      t.integer :order

      t.timestamps
    end
  end
end
