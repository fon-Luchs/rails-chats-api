class ChangeColumnInMessages < ActiveRecord::Migration[5.2]
  def change
    rename_column :messages, :usernae, :username
  end
end
