class ChangesColumnNameNicknameToUsername < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :nickname, :username
  end
end
