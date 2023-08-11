class RenameTierListToTier < ActiveRecord::Migration[7.0]
  def change
    rename_table :tier_lists, :tiers
  end
end
