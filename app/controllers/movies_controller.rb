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
    else
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
    @category1 = "Thriller"
    @result1 = JSON.parse(Home::MovieService.get_genre_movies(@category1))
    @category2 = "War"
    @result2 = JSON.parse(Home::MovieService.get_genre_movies(@category2))
    @category3 = "Western"
    @result3 = JSON.parse(Home::MovieService.get_genre_movies(@category3))
    @category4 = "Recommendations"
    @result4 = JSON.parse(Home::MovieService.get_genre_movies(@category4))
    render json: { entries: render_to_string(partial: 'movies/index_genres_category', formats: [:html]) }
  end

  def without_scroll
    @action_adventure = JSON.parse(Home::MovieService.action_adventure)
    @trending = JSON.parse(Home::MovieService.trending)
    @fantasy = JSON.parse(Home::MovieService.fantasy)
    @horror = JSON.parse(Home::MovieService.horror)
    @popular_movie = JSON.parse(Home::HomeService.popular(nil))
  end

  def specific_genre_movies
    genre_ids = params[:genre_ids].is_a?(Array) ? params[:genre_ids].join(',') : JSON.parse(params[:genre_ids]).join(',')
    @specific_genre = JSON.parse(Home::MovieService.specifics_genres(params, genre_ids))
    @genre_name = Genre.where(genre_id: params[:genre_ids]).pluck(:genre_name).join(' & ')
    if params[:next_page].present?
      render json: { entries: render_to_string(partial: 'movies/view_modal_card', formats: [:html]) }
    else
      render json: { entries: render_to_string(partial: 'movies/view_modal_data', formats: [:html]) }
    end
  end
end
