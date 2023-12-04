class ProfileController < ApplicationController
  before_action :authenticate_user!, except: :show_album

  def index; end

  def cover_photo
    if current_user.update(cover_image_params)
      flash[:notice] = "Cover Photo Successfully Updated"
    else
      flash[:alert] = "Something Went Wrong"
    end
    redirect_to profile_path
  end

  def profile_image
    if current_user.update(profile_image_params)
      flash[:notice] = "Profile Image Successfully Updated"
    else
      flash[:alert] = "Something Went Wrong"
    end
    redirect_to profile_path
  end

  def update
    @user = current_user

    if invalid_current_password?(params[:current_password])
      redirect_to profile_path
      return
    end

    update_user_profile(params[:password], params[:current_password])

    redirect_to profile_path
  end

  def invalid_current_password?(current_password)
    return false unless current_password.present? && !current_user.valid_password?(current_password)

    flash[:alert] = "Current Password is incorrect"
    true
  end

  def update_user_profile(password, current_password)
    if password.present?
      if current_password.blank?
        flash[:alert] = "Current Password is required for updating password"
      else
        if @user.update(user_params_with_password)
          flash[:notice] = "Password Updated Successfully"
          sign_in :user, @user, bypass: true
        else
          flash[:alert] = @user.errors.full_messages.first
        end
      end
    else
      if @user.update(user_params_without_password)
        flash[:notice] = "Profile Updated Successfully"
      else
        flash[:alert] = @user.errors.full_messages.first
      end
    end
  end

  def albums
    @albums = current_user.albums.order('created_at DESC')
  end

  def create_album
    @album = Album.new(album_params)
    if @album.save
      link = "#{ENV['WEBSITE_URL']}/album/#{current_user.username&.split(' ')&.join}/#{@album.title.split(' ').join}?user=#{current_user.id}&album=#{@album.id}"
      flash[:notice] = "#{@album.title} created successfully with shareable link #{link}"
      if params[:movie_id].present?
        create_album_movie(params, @album)
      elsif params[:season_id].present?
        create_album_season(params, @album)
      end
      @album.update(shareable_link: link)
    else
      flash[:alert] = @album.errors.full_messages
    end
    redirect_to albums_path
  end

  def create_album_movie(params, album)
    @movie_detail = JSON.parse(Home::MovieService.movie_details(params))
    if @movie_detail.present?
      album.album_contents.create(movie_id: @movie_detail['id'], imdb_id: @movie_detail['imdb_id'], original_title: @movie_detail['original_title'], release_date: @movie_detail['release_date'], rating: @movie_detail['vote_average'], votes: @movie_detail['vote_count'], img_url: @movie_detail['poster_path'], description: @movie_detail['overview'])
    end
  end

  def create_album_season(params, album)
    @season_detail = JSON.parse(Home::TvShowService.get_season_detail(params))
    if @season_detail.present?
      album.album_contents.create(movie_id: @season_detail['id'], imdb_id: @season_detail['imdb_id'], original_title: @season_detail['original_name'], release_date: @season_detail['first_air_date'], rating: @season_detail['vote_average'], votes: @season_detail['vote_count'], img_url: @season_detail['poster_path'], description: @season_detail['overview'])
    end
  end

  def add_movie
    @movie_detail = JSON.parse(Home::MovieService.movie_details(params))
    @album = Album.find_by(id: params[:album_id])
    if @movie_detail.present?
      @album.album_contents.create(movie_id: @movie_detail['id'], imdb_id: @movie_detail['imdb_id'], original_title: @movie_detail['original_title'], release_date: @movie_detail['release_date'], rating: @movie_detail['vote_average'], votes: @movie_detail['vote_count'], img_url: @movie_detail['poster_path'], description: @movie_detail['overview'])
      render json: { message: "#{@movie_detail['original_title']} added successfully in #{@album.title} album" }, status: :ok
    end
  end

  def add_series
    @tv_detail = JSON.parse(Home::TvShowService.get_season_detail(params))
    @album = Album.find_by(id: params[:album_id])
    if @tv_detail.present?
      @album.album_contents.create(movie_id: @tv_detail['id'], imdb_id: @tv_detail['imdb_id'], original_title: @tv_detail['original_name'], release_date: @tv_detail['first_air_date'], rating: @tv_detail['vote_average'], votes: @tv_detail['vote_count'], img_url: @tv_detail['poster_path'], description: @tv_detail['overview'])
      render json: { message: "#{@tv_detail['original_name']} added successfully in #{@album.title} album" }, status: :ok
    end
  end

  def show_album
    @user = User.find_by(id: params[:user])
    @album = Album.find_by(id: params[:album])
    @album.increment(:total_views).save
  end

  def show_album_data
    @album = Album.find(params[:id])
    render json: { entries: render_to_string(partial: 'profile/show_album_modal_close_button', formats: [:html]) }
  end

  def movies_dropdown_data
    @genre = Genre.find(params[:genre_id])
    @dropdown_data = JSON.parse(Home::MovieService.get_genre_movies(@genre.genre_name))
    render json: { entries: render_to_string(partial: 'profile/dropdown', formats: [:html]) }
  end

  def show_dropdown_data
    @genre = TvGenre.find(params[:genre_id])
    @dropdown_data = JSON.parse(Home::TvShowService.get_genre_shows(@genre.genre_name))
    render json: { entries: render_to_string(partial: 'profile/dropdown', formats: [:html]) }
  end

  def followers
    @followers = current_user.followers.where(status: 1)
  end

  def followings
    @followings = current_user.followings.where(status: 1)
  end

  def explore
    followings = current_user.followings.where(status: [0, 1, 2])
    excluded_user_ids = [current_user.id] + followings.pluck(:following_id)
    @users = User.where.not(id: excluded_user_ids).order(:username)
  end

  def pending_requests
    @pending_requests = current_user.followers.where(status: 0)
  end

  def unfollow
    @user = User.find_by(id: params[:following_id])
    @following = Following.find_by(following_id: params[:following_id], user_id: current_user.id)
    @follower = Follower.find_by(user_id: params[:following_id], follower_id: current_user.id)
    @following.destroy; @follower.destroy
    flash[:notice] = "#{@user.username} UnFollowed Successfully"
    redirect_to followings_path
  end

  def unfriend
    @user = User.find_by(id: params[:follower_id])
    @following = Following.find_by(user_id: params[:follower_id], following_id: current_user.id)
    @follower = Follower.find_by(user_id: current_user.id, follower_id: params[:follower_id])
    @following.destroy; @follower.destroy
    flash[:notice] = "#{@user.username} UnFriend Successfully"
    redirect_to followers_path
  end

  def settings
    @settings = current_user.setting
  end

  def update_settings
    current_user.setting.update(setting_params)
    render json: { message: 'Updated Successfully' }, status: :ok
  end


  private

  def album_params
    params.permit(:title, :private, :album_type, :album_genre, :album_image).merge(user_id: current_user.id)
  end

  def cover_image_params
    params.permit(:cover_image)
  end

  def profile_image_params
    params.permit(:profile_image)
  end

  def user_params_with_password
    params.permit(:username, :password, :password_confirmation)
  end

  def user_params_without_password
    params.permit(:username)
  end

  def setting_params
    params.permit(:private_account, :private_albums, :adult_content)
  end
end
