class ChatsController < ApplicationController
  before_action :set_chat, only: [:add, :leave, :show]

  def index
    @chats = current_user.chats.all
    @chats.each do |chat|
      chat.chat_without_message?
      render json: chat, symbolize_names: true, root: false
    end
  end

  def show
    @chat.chat_without_message?
    render json: @chat
  end

  def create
    @chat = Chat.new(chat_param)
    @chat.users << current_user
    @chat.users << recipient
    @chat.last_message = 'Welcome to the chat'
    if @chat.save
      render json: @chat
    else
      render json: @chat.errors
    end
  end

  def add
    @chat.chat_without_message?
    @join_user = @chat.user_chats.where(user_id: current_user.id).first_or_create
    if @join_user.save
      render status: :ok, json: @chat
    else
      render json: @chat_room.errors
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

  def check_messages_in_the_chat
    @chat.chat_without_message?
  end

  def recipient
    @recipient = User.where(id: @chat.recipient_id)
  end

  def chat_param
    params.require(:chat).permit(:recipient_id)
  end

  def set_chat
    @chat ||= Chat.find(params[:id])
  end
end