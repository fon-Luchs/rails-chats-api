class ChatSerializer < ActiveModel::Serializer
  attributes :id, :users, :show_last_message
  has_many :users

  def show_last_message
    if !:last_message.nil?
      object.last_message
    end  
  end  
end
