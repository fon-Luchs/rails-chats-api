module ChatCreatable
  extend ActiveSupport::Concern

  included do
    before_action :set_new_chat, only: :create
  end

  def set_new_chat
    @chat = Chat.new(chat_param)
    @chat.users << current_user
    @chat.users << recipient
  end

  def recipient
    @recipient = User.where(id: @chat.recipient_id)
  end
end