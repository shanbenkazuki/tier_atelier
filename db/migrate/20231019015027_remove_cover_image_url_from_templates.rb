class RemoveCoverImageUrlFromTemplates < ActiveRecord::Migration[7.0]
  def change
    remove_column :templates, :cover_image_url, :string
  end
end
