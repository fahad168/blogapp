class ProfileController < ApplicationController
  before_action :authenticate_user!, except: :show_album

  def index; end

  def albums
    @albums = current_user.albums.order('created_at DESC')
  end

  def create_album
    @album = Album.new(album_params)
    if @album.save
      link = "#{ENV['WEBSITE_URL']}/album/#{current_user.username}/#{@album.title}?user=#{current_user.id}&album=#{@album.id}"
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

  def show_album
    @user = User.find_by(id: params[:user])
    @album = Album.find_by(id: params[:album])
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

  private

  def album_params
    params.permit(:title, :private, :album_type, :album_genre).merge(user_id: current_user.id)
  end
end
