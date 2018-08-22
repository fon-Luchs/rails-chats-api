class ChatSerializer < ActiveModel::Serializer
  attributes :id, :users, :last_message
  has_many :users
end
