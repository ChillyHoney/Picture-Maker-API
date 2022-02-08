class CreatePictures < ActiveRecord::Migration[6.1]
  def change
    create_table :pictures do |t|
      t.string :description
      t.references :user, foreign_key: true, null: false
    end
  end
end
