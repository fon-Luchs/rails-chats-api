class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  has_one :auth_token, dependent: :destroy
  has_many :user_chats, dependent: :destroy
  has_many :messages
  has_many :chats, through: :user_chats
end
