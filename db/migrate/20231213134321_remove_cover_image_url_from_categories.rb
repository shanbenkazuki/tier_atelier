class RemoveCoverImageUrlFromCategories < ActiveRecord::Migration[7.0]
  def change
    remove_column :categories, :cover_image_url, :string
  end
end
