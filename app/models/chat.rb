class Chat < ApplicationRecord
  has_many :user_chats
  has_many :users, dependent: :destroy, through: :user_chats
  validates :users, length: { in: 2..8 }
end
