class UsersController < ApplicationController
  def show
    @users = User.all
    render json: @users
  end
end