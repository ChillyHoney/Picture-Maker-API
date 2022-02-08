class AddFavouriteToPictures < ActiveRecord::Migration[6.1]
  def change
    add_column :pictures, :is_favourite, :boolean, :default => false
  end
end
