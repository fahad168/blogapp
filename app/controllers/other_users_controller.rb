class OtherUsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id).first(20)
  end

  def other_user_profile
    @user = User.find_by(id: params[:id])
  end
end
