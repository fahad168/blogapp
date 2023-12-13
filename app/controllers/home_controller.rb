class HomeController < ApplicationController
  def index
    if params[:type].present?
      @top_rated_movies = JSON.parse(Home::HomeService.top_rated(nil))
      @top_rated_shows = JSON.parse(Home::HomeService.top_rated_shows(nil))
      @lollywood_movies = JSON.parse(Home::HomeService.lollywood(nil))
      @bollywood_movies = JSON.parse(Home::HomeService.bollywood(nil))
      respond_to do |format|
        format.json { render json: { entries: render_to_string(partial: 'home/home_data', formats: [:html]) } }
      end
    else
      @trending_all = JSON.parse(Home::HomeService.trending_all)
      @playing_now = JSON.parse(Home::HomeService.now_playing(nil))
      @popular = JSON.parse(Home::HomeService.popular(nil))
    end
  end

  def get_modal_data
    @movie_detail = JSON.parse(Home::MovieService.movie_details(params))
    @movie_videos = JSON.parse(Home::MovieService.movie_videos(params))
    @similar_movies = JSON.parse(Home::MovieService.similar_movies(params))
    @trailer = @movie_videos['results']&.select { |item| item['type'] == "Trailer" }&.first
    @clips = @movie_videos['results']&.select { |item| item['type'] == "Clip" }
    respond_to do |format|
      format.html
      format.json { render json: { entries: render_to_string(partial: 'home/modal_data', formats: [:html]) } }
    end
  end

  def get_season_data
    @season_detail = JSON.parse(Home::TvShowService.get_season_detail(params))
    @season_videos = JSON.parse(Home::TvShowService.season_videos(params))
    @episode_details = JSON.parse(Home::TvShowService.season1(@season_detail))
    if @season_videos['results'] != []
      @trailer = @season_videos['results'].select { |item| item['type'] == "Trailer" }.first
      @clips = @season_videos['results'].select { |item| item['type'] == "Clip" }
    end
    respond_to do |format|
      format.html
      format.json { render json: { entries: render_to_string(partial: 'home/tv_modal_data', formats: [:html]) } }
    end
  end

  def episodes_details
    @episode_details = JSON.parse(Home::TvShowService.episode_details(params))
    render json: { entries: render_to_string(partial: 'home/episode_details', formats: [:html]) }
  end

  def view_all
    @result = JSON.parse(Home::ViewAllService.get_all_data(params))
    if params[:next_page].present?
      respond_to do |format|
        format.html
        format.json { render json: { entries: render_to_string(partial: 'home/view_page_result', formats: [:html]) } }
      end
    end
  end

  def search_results
    @search_results = JSON.parse(Home::SearchService.new(params, current_user).base_method)
    @keywords_suggestions = JSON.parse(Home::SearchService.keywords_suggestions(params))
  end

  def person_detail
    @person_details = JSON.parse(Home::HomeService.get_person_details(params))
    @person_data = JSON.parse(Home::HomeService.get_person_data(params))
  end
end
