class ChatSerializer < ActiveModel::Serializer
  attributes :id, :last_message
  has_many :users
end
