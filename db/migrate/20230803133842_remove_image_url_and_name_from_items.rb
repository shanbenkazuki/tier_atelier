class RemoveImageUrlAndNameFromItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :image_url, :string
    remove_column :items, :name, :string
  end
end
