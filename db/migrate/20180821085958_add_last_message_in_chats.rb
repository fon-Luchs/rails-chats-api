class AddLastMessageInChats < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :last_message, :string
  end
end
