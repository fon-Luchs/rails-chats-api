class UserChat < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validate :validate_user_chats_count

  def validate_user_chats_count
    errors.add(:user, :invalid) if user.chats.count > 9
  end
end