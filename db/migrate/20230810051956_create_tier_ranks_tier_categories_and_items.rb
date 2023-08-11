class CreateTierRanksTierCategoriesAndItems < ActiveRecord::Migration[7.0]
  def change
    create_table :tier_ranks do |t|
      t.references :tier_list, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :order, null: false

      t.timestamps
    end

    create_table :tier_categories do |t|
      t.references :tier_list, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :order, null: false

      t.timestamps
    end

    create_table :items do |t|
      t.references :tier_list, null: false, foreign_key: true
      t.references :rank, null: false, foreign_key: { to_table: :tier_ranks }
      t.references :category, null: false, foreign_key: { to_table: :tier_categories }

      t.timestamps
    end
  end
end
