class CreateTierTemplateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :tier_template_relationships do |t|
      t.references :tier, null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
