class FollowingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_following_user, only: :create

  def create
    @following = Following.create(following_id: params[:following_id], user_id: current_user.id, status: 'Pending')
    @follower = Follower.create(follower_id: current_user.id, user_id: params[:following_id], status: 'Pending')
    render json: { message: "Follow request sent successfully to #{@following_user.username}" }, status: :ok
  end

  def cancel
    @record = current_user.followings.find_by(following_id: params[:following_id], user_id: current_user.id)
    @record1 =  Follower.find_by(follower_id: current_user.id, user_id: params[:following_id])
    @record.destroy; @record1.destroy
    render json: { message: "Follow request canceled successfully" }, status: :ok
  end

  def update_request
    @record = current_user.followers.find_by(follower_id: params[:follower_id], user_id: current_user.id)
    @follower = User.find_by(id: params[:follower_id])
    @record1 = @follower.followings.where(following_id: current_user.id, user_id: @follower.id)
    if params[:type] == "Accept"
      @record.update(status: 1)
      @record1.update(status: 1)
      flash[:notice] = "Request Accepted"
    else
      @record.update(status: 2)
      @record1.update(status: 2)
      flash[:alert] = "Request Rejected"
    end
    redirect_to pending_requests_path
  end

  private

  def find_following_user
    unless (@following_user = User.find_by(id: params[:following_id]))
      return render json: { error: "User not found" }, status: :ok
    end
  end
end
