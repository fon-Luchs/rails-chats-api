class ChatsController < ApplicationController
  before_action :set_chat, only: [:add, :leave, :show]
  before_action :set_new_chat, only: :create

  def index
    @chats = current_user.chats.all
    @chats.each(&:chat_without_message?)
    render json: @chats
  end

  def show
    render json: @chat
  end

  def create
    if @chat.save
      render json: @chat
    else
      render json: @chat.errors
    end
  end

  def add
    @join_user = @chat.user_chats.where(user_id: current_user.id).first_or_create
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

  def recipient
    @recipient = User.where(id: @chat.recipient_id)
  end

  def chat_param
    params.require(:chat).permit(:recipient_id)
  end

  def set_chat
    @chat ||= Chat.find(params[:id])
    @chat.chat_without_message?
  end

  def set_new_chat
    @chat = Chat.new(chat_param)
    @chat.users << current_user
    @chat.users << recipient
  end
end