class Chat < ApplicationRecord
  attr_accessor :last_message

  has_many :user_chats, dependent: :destroy
  has_many :users,  through: :user_chats
  has_many :messages, dependent: :destroy

  def chat_without_message?
    self.last_message = if last_message.nil?
                          'Welcome to the chat'
                        else
                          messages.body.last
                        end
  end
end
