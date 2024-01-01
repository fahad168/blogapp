class MoviesController < ApplicationController
  def index
    if params[:next_scroll].present? && params[:next_scroll] == '1'
      get_scroll_1
    elsif params[:next_scroll].present? && params[:next_scroll] == '2'
      get_scroll_2
    elsif params[:next_scroll].present? && params[:next_scroll] == '3'
      get_scroll_3
    elsif params[:next_scroll].present? && params[:next_scroll] == '4'
      get_scroll_4
    elsif !params[:next_scroll].present?
      without_scroll
    end
  end

  def get_scroll_1
    @category1 = "Animation"
    @result1 = JSON.parse(Home::MovieService.get_genre_movies(@category1))
    @category2 = "Comedy"
    @result2 = JSON.parse(Home::MovieService.get_genre_movies(@category2))
    @category3 = "Crime"
    @result3 = JSON.parse(Home::MovieService.get_genre_movies(@category3))
    @category4 = "Documentary"
    @result4 = JSON.parse(Home::MovieService.get_genre_movies(@category4))
    render json: { entries: render_to_string(partial: 'movies/index_genres_category', formats: [:html]) }
  end

  def get_scroll_2
    @category1 = "Drama"
    @result1 = JSON.parse(Home::MovieService.get_genre_movies(@category1))
    @category2 = "Family"
    @result2 = JSON.parse(Home::MovieService.get_genre_movies(@category2))
    @category3 = "History"
    @result3 = JSON.parse(Home::MovieService.get_genre_movies(@category3))
    @category4 = "Music"
    @result4 = JSON.parse(Home::MovieService.get_genre_movies(@category4))
    render json: { entries: render_to_string(partial: 'movies/index_genres_category', formats: [:html]) }
  end

  def get_scroll_3
    @category1 = "Mystery"
    @result1 = JSON.parse(Home::MovieService.get_genre_movies(@category1))
    @category2 = "Romance"
    @result2 = JSON.parse(Home::MovieService.get_genre_movies(@category2))
    @category3 = "Science Fiction"
    @result3 = JSON.parse(Home::MovieService.get_genre_movies(@category3))
    @category4 = "TV Movie"
    @result4 = JSON.parse(Home::MovieService.get_genre_movies(@category4))
    render json: { entries: render_to_string(partial: 'movies/index_genres_category', formats: [:html]) }
  end

  def get_scroll_4
    @category1 = "Horror"
    @result1 = JSON.parse(Home::MovieService.get_genre_movies(@category1))
    @category2 = "Thriller"
    @result2 = JSON.parse(Home::MovieService.get_genre_movies(@category2))
    @category3 = "War"
    @result3 = JSON.parse(Home::MovieService.get_genre_movies(@category3))
    @category4 = "Western"
    @result4 = JSON.parse(Home::MovieService.get_genre_movies(@category4))
    render json: { entries: render_to_string(partial: 'movies/index_genres_category', formats: [:html]) }
  end

  def without_scroll
    @trending = Rails.cache.fetch("movies_trending", expires_in: 12.hours) do
      JSON.parse(Home::MovieService.trending)
    end
    @action_adventure = Rails.cache.fetch("movies_action_adventure", expires_in: 12.hours) do
      JSON.parse(Home::MovieService.action_adventure)
    end
    @fantasy = Rails.cache.fetch("movies_fantasy", expires_in: 12.hours) do
      JSON.parse(Home::MovieService.fantasy)
    end
    @upcoming = Rails.cache.fetch("movies_upcoming", expires_in: 12.hours) do
      JSON.parse(Home::MovieService.upcoming)
    end
    @popular_movie = Rails.cache.fetch("movies_popular", expires_in: 12.hours) do
      JSON.parse(Home::HomeService.popular(nil))
    end
    # @trending = JSON.parse(Home::MovieService.trending)
    # @action_adventure = JSON.parse(Home::MovieService.action_adventure)
    # @fantasy = JSON.parse(Home::MovieService.fantasy)
    # @upcoming = JSON.parse(Home::MovieService.upcoming)
    # @popular_movie = JSON.parse(Home::HomeService.popular(nil))
  end

  def specific_genre_movies
    if params[:q].present? && params[:q] != ""
      filter_movies_by_name(params)
    else
      genre_ids = params[:genre_ids].is_a?(Array) ? params[:genre_ids].join(',') : JSON.parse(params[:genre_ids]).join(',')
      @specific_genre = JSON.parse(Home::MovieService.specifics_genres(params, genre_ids))
      @genre_name = Genre.where(genre_id: params[:key].present? ? JSON.parse(params[:genre_ids]) : params[:genre_ids]).pluck(:genre_name).join(' & ')
      if params[:next_page].present?
        render json: { entries: render_to_string(partial: 'movies/view_modal_card', formats: [:html]) }
      else
        render json: { entries: render_to_string(partial: 'movies/view_modal_data', formats: [:html]) }
      end
    end
  end

  def filter_movies_by_name(params)
    search_results = JSON.parse(Home::MovieService.search_movie(params))
    @total_pages = search_results['total_pages']
    @genre_name = params[:genre_name]
    genre_id = case @genre_name
               when 'Science'
                 Genre.find_by(genre_name: 'Science Fiction')&.genre_id
               when 'Action'
                 Genre.where(genre_name: %w[Action Adventure]).pluck(:genre_id)
               else
                 Genre.find_by(genre_name: @genre_name)&.genre_id
               end
    if search_results['results'].present?
      @specific_genre = search_results['results'].select do |result|
        Array(genre_id).any? { |id| result['genre_ids'].include?(id) }
      end
    else
      @message = "Not Found Any Movie With Name #{params[:q]}"
    end

    if params[:next_page].present?
      render json: { entries: render_to_string(partial: 'movies/view_modal_card', formats: [:html]) }
    else
      render json: { entries: render_to_string(partial: 'movies/view_modal_data', formats: [:html]) }
    end
  end
end
