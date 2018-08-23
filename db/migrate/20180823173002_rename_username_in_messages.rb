class RenameUsernameInMessages < ActiveRecord::Migration[5.2]
  def change
    rename_column :messages, :username, :user_name
  end
end
