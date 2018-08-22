class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :username, :chat_id
end
