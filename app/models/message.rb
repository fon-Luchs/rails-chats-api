class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :body, length: { in: 3..255 }

  def messages_usernme
    self.username = user.name
  end  
end
