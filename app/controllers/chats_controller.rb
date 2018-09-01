class ChatsController < ApplicationController

  before_action :set_chat, only: [:add, :leave, :show]

  def index
    @chats = current_user.chats.all
    render json: @chats
  end

  def show
    @chat.chat_without_message?
    render json: @chat, serializer: ChatWithLastMessageSerializer
  end

  def add
    @join_user = @chat.user_chats.find_or_create_by(user_id: current_user.id)
    if @join_user.save
      render status: :ok, json: @chat
    else
      render json: @join_user.errors
    end
  end

  def leave
    @leave_user = @chat.user_chats.where(user_id: current_user.id).destroy_all
    @msg = 'Chat is inactive'
    if @chat.users.size < 2
      @chat.destroy
      render status: 410, json: @msg
    else
      render status: :ok, json: @chat
    end
  end

  private

  def set_chat
    @chat ||= Chat.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(:recipient_id)
  end

  def resource
    @chat ||= ChatBuilder.new(chat_params, current_user)
  end
end