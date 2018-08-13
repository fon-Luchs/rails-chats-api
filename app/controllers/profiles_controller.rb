class ProfilesController < ApplicationController
  skip_before_action :authenticate!, only: :create

  before_action :build_resource, only: :create

  def show
    @user = current_user
    # @user.name = nil
    # @user.updated_at = nil
    # @user.created_at = nil
    # @user.password_digest = nil
    # @user.id = nil

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
