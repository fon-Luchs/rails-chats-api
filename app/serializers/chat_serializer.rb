class ChatSerializer < ActiveModel::Serializer
  attributes :id, :users
  has_many :users
end
