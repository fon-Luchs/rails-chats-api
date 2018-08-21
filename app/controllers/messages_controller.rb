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

    @chat = Chat.find(params[:chat_id])
    @messages = @chat.messages.order('created_at DESC').paginate(page: params[:page], per_page: 5)

    render json: @messages,  root: false
  end

  private

  def resource
    @user ||= current_user  
  end

  def messages_params
    params.require(:message).permit(:body, :chat_id, :user_id)
  end
end