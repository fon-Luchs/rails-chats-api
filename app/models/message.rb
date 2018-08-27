class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :body, length: { in: 3..255 }
  validates :user_name, presence: true

  delegate :name, to: :user, prefix: 'user'
end
