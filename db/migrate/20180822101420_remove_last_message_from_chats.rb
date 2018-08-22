class RemoveLastMessageFromChats < ActiveRecord::Migration[5.2]
  def change
    remove_column :chats, :last_message
  end
end
