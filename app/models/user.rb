class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_associated :chats, length: { maximum: 10 }
  has_one :auth_token, dependent: :destroy
  has_many :user_chats
  has_many :messages
  has_many :chats, dependent: :destroy, through: :user_chats
end
