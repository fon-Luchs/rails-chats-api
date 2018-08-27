class UsersController < ApplicationController
  def show
    @users = User.all
    render json: @users
  end

  private

  def resource
    @user ||= current_user
  end
end