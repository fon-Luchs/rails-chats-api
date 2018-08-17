class CreateUserChats < ActiveRecord::Migration[5.2]
  def change
    create_table :user_chats do |t|
      t.references :chat, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
