class ChatsController < ApplicationController

  before_action :set_chat, only: [:add, :leave]
  before_action :authenticate!

  def index
    @chats = Chat.all
    render json: @chats, symbolize_names: true, root: false
  end

  def show
    @chat = Chat.find(params[:id])
    @chat.last_message = @chat.messages.last.body

    render json: @chat
  end

  def create
    @chat = Chat.new(chat_param)
    if @chat.save
     user_chat_filling
     render json: @chat
    end
  end

  def add
    @chat_room = @chat.user_chats.where(user_id: current_user.id).first_or_create
  end

  def leave
    @chat_room = @chat.user_chats.where(user_id: current_user.id).destroy_all
  end

  private


  def resource
    @user ||= current_user
  end

  def resource_param
  end

  def user_chat_filling
    UserChat.create([
                        {user_id: current_user.id, chat_id: @chat.id},
                        {user_id: @chat.recipient_id, chat_id: @chat.id}
                    ])
  end

  def chat_param
    params.require(:chat).permit(:recipient_id)
  end

  def set_chat
    @chat ||= Chat.find(params[:id])
  end

end