class UsersController < ApplicationController
  def show
    @users = User.all
    render json: @users, only: %i[name id], symbolize_names: true
  end

  private

  def resource
    @user ||= current_user
  end
end