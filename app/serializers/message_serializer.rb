class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :chat_id
end
