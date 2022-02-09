class AddUsernameIndexWithUniqueFalse < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :username, unique: false
  end
end
