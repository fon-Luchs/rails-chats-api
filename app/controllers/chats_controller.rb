class ChatsController < ApplicationController

  before_action :set_chat, only: [:add, :leave]
  before_action :authenticate!

  def index
    @chats = Chat.all
    render json: @chats, symbolize_names: true
  end

  def create

  end

  def add
    @chat_room = @chat.user_chats.where(user_id: current_user.id).first_or_create
  end

  def leave
    @chat_room = @chat.user_chats.where(user_id: current_user.id).destroy_all
  end

  private

  def set_chat
    @chat ||= Chat.find(params[:id])
  end

end