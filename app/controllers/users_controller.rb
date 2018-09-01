class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users, each_serializer: UserShowSerializer
  end

  private 

  def resource
    @user ||= current_user
  end
end
