class ChatsController < ApplicationController

  before_action :set_chat, only: [:add, :leave]
  before_action :authenticate!

  def index
    @chats = Chat.all
    render json: @chats, symbolize_names: true
  end

  def create
    @other_user = User.find(params[:other_user])
    @chat = find_chat(@other_user) || Chat.new
    if !@chat.persisted?
      @chat.save
      @chat.user_chats.create(user_id: current_user.id)
      @chat.user_chats.create(user_id: @other_user.id)
    end
  end

  def add
    @chat_room = @chat.user_chats.where(user_id: current_user.id).first_or_create
  end

  def leave
    @chat_room = @chat.user_chats.where(user_id: current_user.id).destroy_all
  end

  private

  def find_chat(second_user)
    chats = current_user.chats
    chats.each do |chat|
      chat.subscriptions.each do |s|
        chat if s.user_id == second_user.id
      end
    end
    nil
  end

  def set_chat
    @chat ||= Chat.find(params[:id])
  end

end