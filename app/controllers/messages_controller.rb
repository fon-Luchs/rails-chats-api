class MessagesController < ApplicationController

  before_action :authenticate!

  def create
    @message = Message.new(messages_params)
    @message.messages_username
  end

  def index
    @chat = Chat.find(params[:id])
    @message = chat.messages

    render json: @message, symbolize_names: true, root: false
  end

  private

  def messages_params
    params.require(:message).permit(:body, :chat_id)
  end
end