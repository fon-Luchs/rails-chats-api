class MessagesController < ApplicationController

  def create

    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.new(messages_params)
    @message.messages_username

    if @message.save
      render json: @message, root: false
    end   
  end

  def index
    @chat = Chat.find(params[:chat_id])
    @messages = @chat.messages.order('created_at DESC').paginate(page: params[:page], per_page: PER_PAGE_SIZE)

    render json: @messages,  root: false
  end

  private

  PER_PAGE_SIZE = 30

  def resource
    render json: @message.errors
  end

  def messages_params
    params.require(:message).permit(:body).merge(user_id: current_user.id)
  end
end