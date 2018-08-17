class MessagesController < ApplicationController
  def create
    @message = Message.new(messages_params)
  end

  private

  def messages_params
    params.require(:message).permit(:body, :chat_id)
  end
end