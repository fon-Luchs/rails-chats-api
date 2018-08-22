class UserChat < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validate :validate_user_chats_count
  validate :validate_users_in_the_chat

  def validate_users_in_the_chat
    errors.add(:chat, :invalid) if chat.users.size > 8
  end

  def validate_user_chats_count
    errors.add(:user, :invalid) if user.chats.size > 9
  end
end