class CreatePictures < ActiveRecord::Migration[6.1]
  def change
    create_table :pictures do |t|
      t.string :filename, null: false
      t.string :description
      t.boolean :is_favourite, default: false, null: false
      t.references :user, foreign_key: true, null: false
    end
  end
end
