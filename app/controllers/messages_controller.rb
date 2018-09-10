class MessagesController < ApplicationController
  before_action :set_chat

  def create
    @message = @chat.messages.new(messages_params)

    if @message.save
      @chat.chat_without_message?
      render json: @chat, root: false, serializer: ChatWithLastMessageSerializer
    else
      render json: @message.errors
    end
  end

  def index
    @messages = @chat.messages.order('created_at DESC').paginate(
      page: params[:page],
      per_page: PER_PAGE_SIZE
    )

    render json: @chat, root: false, serializer: ChatWithinShowSerializer
  end

  private

  PER_PAGE_SIZE = 30

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def messages_params
    params.require(:message).permit(:body).merge(user_id: current_user.id)
  end
end
