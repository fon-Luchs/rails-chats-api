class ChatBuilder
  def initialize params={}, current_user
    @params = params
    @current_user = current_user
  end

  def build
    chat = Chat.new(@params)
    chat.users << @current_user
    chat.users << recipient
    chat
  end

  def recipient
    recipient ||= User.find(@params[:recipient_id])
  end

end