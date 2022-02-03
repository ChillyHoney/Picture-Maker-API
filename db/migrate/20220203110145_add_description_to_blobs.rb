class AddDescriptionToBlobs < ActiveRecord::Migration[6.1]
  def change
    add_column :active_storage_blobs, :description, :string
  end
end
