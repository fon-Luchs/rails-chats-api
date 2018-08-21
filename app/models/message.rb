class Message < ApplicationRecord
  PER_PAGE_SIZE = 30
  
  belongs_to :chat
  belongs_to :user

  validates :body, length: { in: 3..255 }

  def messages_username
    self.username = user.name
  end  
end
