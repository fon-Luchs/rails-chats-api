class ProfilesController < ApplicationController
  skip_before_action :authenticate!, only: :create

  before_action :build_resource, only: :create
  before_action :resource, only: [:show, :chats]

  def show
    render json: @user, only: %i[email], symbolize_names: true
  end

  private
  def build_resource
    @user = User.new resource_params
  end

  def resource
    @user ||= current_user
  end

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
