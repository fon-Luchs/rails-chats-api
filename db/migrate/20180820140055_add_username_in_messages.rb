class AddUsernameInMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :usernae, :string
  end
end
