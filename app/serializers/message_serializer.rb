class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_name, :chat_id
end
