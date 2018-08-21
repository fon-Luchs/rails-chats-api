class ChatsController < ApplicationController

  before_action :set_chat, only: [:add, :leave]

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
    @chat.users << current_user
    @chat.users << recipient
    if @chat.save 
     render json: @chat
    else
      render json: @chat.errors
    end
  end

  def add
    @chat_room = @chat.user_chats.where(user_id: current_user.id).first_or_create
    if @chat_room.save
      render status: :ok, json: @chat
    else
      render json: @chat_room.errors
    end  
  end

  def leave
    @chat_room = @chat.user_chats.where(user_id: current_user.id).destroy_all
    render status: :ok, json: @chat

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
  end

end