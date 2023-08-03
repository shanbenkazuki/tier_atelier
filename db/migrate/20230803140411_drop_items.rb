class DropItems < ActiveRecord::Migration[7.0]
  def up
    drop_table :items
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
