class OtherUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, except: :index

  def index
    @users = User.where.not(id: current_user.id).first(20)
  end

  def other_user_profile; end

  def other_user_albums
    @other_albums = @user.albums
  end

  def other_user_followers
    @followers = @user.followers.where(status: 1).order('created_at DESC')
  end

  def other_user_followings
    @followers = @user.followings.where(status: 1).order('created_at DESC')
  end

  private

  def find_user
    @user = User.find_by(id: params[:id])
  end
end
