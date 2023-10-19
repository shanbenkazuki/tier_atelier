class DropTemplateItems < ActiveRecord::Migration[7.0]
  def up
    drop_table :template_items
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
