class CreateTemplateRanks < ActiveRecord::Migration[7.0]
  def change
    create_table :template_ranks do |t|
      t.references :template, null: false, foreign_key: true
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
