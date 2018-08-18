class AddRecipientInChats < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :recipient_id, :integer
  end
end
