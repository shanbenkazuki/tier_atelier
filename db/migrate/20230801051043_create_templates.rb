class CreateTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :cover_image_url
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
