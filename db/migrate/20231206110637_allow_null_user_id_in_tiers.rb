class AllowNullUserIdInTiers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :tiers, :user_id, true
  end
end
