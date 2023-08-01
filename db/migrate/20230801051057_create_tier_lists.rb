class CreateTierLists < ActiveRecord::Migration[7.0]
  def change
    create_table :tier_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
