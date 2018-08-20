class MessagesController < ApplicationController

  before_action :authenticate!

  def create

    @message = Message.new(messages_params)
    # @message.messages_username

    if @message.save
      render json: @message, root: false
    end   
  end

  def index
    @chat = Chat.find(params[:id])
    @message = chat.messages

    render json: @message, symbolize_names: true,  root: false
  end

  private

  def resource
    @user ||= current_user
  end

  def messages_params
    params.require(:message).permit(:body, :chat_id, :user_id)
  end
end