class UserChat < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validate :validate_user_chats_count
  validate :validate_users_in_the_chat

  def validate_users_in_the_chat
    if chat.users.size > 8
      errors.add(:chat, :invalid) 
    elsif chat.users.size < 2
      inactive_mess = "chat is inactive"
      inactive_mess.to_json
        
    end
  end  

  def validate_user_chats_count
    errors.add(:user, :invalid) if user.chats.size > 9
  end
end