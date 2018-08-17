class MessagesController < ApplicationController
  def create
    @message = Message.new(messages_params)
  end

  def index
    @chat = Chat.find(params[:id])
    @message = chat.messages

    render json: @message, symbolize_names: true
  end

  private

  def messages_params
    params.require(:message).permit(:body, :chat_id)
  end
end