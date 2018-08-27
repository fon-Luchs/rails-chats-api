class Chat < ApplicationRecord
  attr_accessor :last_message

  has_many :user_chats, dependent: :destroy
  has_many :users,  through: :user_chats
  has_many :messages, dependent: :destroy

  def chat_without_message?
    msg = messages.last
    self.last_message = msg.body unless msg.nil?
  end
end
