class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :body, length: { in: 3..255 }

  delegate :name, to: :user, prefix: 'user'
end
