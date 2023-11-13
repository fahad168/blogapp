class TvShowsController < ApplicationController
  def index
    if params[:next_scroll].present? && params[:next_scroll] == '1'
      get_scroll_1
    elsif params[:next_scroll].present? && params[:next_scroll] == '2'
      get_scroll_2
    elsif params[:next_scroll].present? && params[:next_scroll] == '3'
      get_scroll_3
    elsif !params[:next_scroll].present?
      without_scroll
    end
  end

  def without_scroll
    @popular_seasons = JSON.parse(Home::TvShowService.popular_shows)
    @trending = JSON.parse(Home::TvShowService.trending_shows)
    @action_adventure = JSON.parse(Home::TvShowService.action_adventure)
    @sci_fi_fantasy = JSON.parse(Home::TvShowService.sci_fi_fantasy)
    @comedy = JSON.parse(Home::TvShowService.comedy)
  end

  def get_scroll_1
    @category1 = "Crime"
    @result1 = JSON.parse(Home::TvShowService.get_genre_shows(@category1))
    @category2 = "Documentary"
    @result2 = JSON.parse(Home::TvShowService.get_genre_shows(@category2))
    @category3 = "Drama"
    @result3 = JSON.parse(Home::TvShowService.get_genre_shows(@category3))
    @category4 = "Animation"
    @result4 = JSON.parse(Home::TvShowService.get_genre_shows(@category4))
    render json: { entries: render_to_string(partial: 'tv_shows/index_genres_category', formats: [:html]) }
  end

  def get_scroll_2
    @category1 = "Family"
    @result1 = JSON.parse(Home::TvShowService.get_genre_shows(@category1))
    @category2 = "Kids"
    @result2 = JSON.parse(Home::TvShowService.get_genre_shows(@category2))
    @category3 = "Mystery"
    @result3 = JSON.parse(Home::TvShowService.get_genre_shows(@category3))
    @category4 = "News"
    @result4 = JSON.parse(Home::TvShowService.get_genre_shows(@category4))
    render json: { entries: render_to_string(partial: 'tv_shows/index_genres_category', formats: [:html]) }
  end

  def get_scroll_3
    @category1 = "Reality"
    @result1 = JSON.parse(Home::TvShowService.get_genre_shows(@category1))
    @category2 = "Soap"
    @result2 = JSON.parse(Home::TvShowService.get_genre_shows(@category2))
    @category3 = "Talk"
    @result3 = JSON.parse(Home::TvShowService.get_genre_shows(@category3))
    @category4 = "Western"
    @result4 = JSON.parse(Home::TvShowService.get_genre_shows(@category4))
    render json: { entries: render_to_string(partial: 'tv_shows/index_genres_category', formats: [:html]) }
  end

  def specific_genre_shows
    if params[:q].present? && params[:q] != ""
      filter_shows_by_name(params)
    else
      genre_ids = params[:genre_ids].is_a?(Array) ? params[:genre_ids].join(',') : JSON.parse(params[:genre_ids]).join(',')
      @specific_genre = JSON.parse(Home::TvShowService.specifics_genres(params, genre_ids))
      @genre_name = TvGenre.where(genre_id: params[:genre_ids].is_a?(Array) ? params[:genre_ids] : JSON.parse(params[:genre_ids])).pluck(:genre_name).join(' & ')
      if params[:next_page].present?
        render json: { entries: render_to_string(partial: 'tv_shows/view_modal_card', formats: [:html]) }
      else
        render json: { entries: render_to_string(partial: 'tv_shows/view_modal_data', formats: [:html]) }
      end
    end
  end

  def filter_shows_by_name(params)
    search_results = JSON.parse(Home::TvShowService.search_show(params))
    @total_pages = search_results['total_pages']
    @genre_name = params[:genre_name]
    genre_id = case @genre_name
               when 'Sci-Fi'
                 TvGenre.find_by(genre_name: 'Sci-Fi & Fantasy')&.genre_id
               when 'Action'
                 TvGenre.find_by(genre_name: 'Action & Adventure')&.genre_id
               else
                 TvGenre.find_by(genre_name: @genre_name)&.genre_id
               end
    if search_results['results'].present?
      @specific_genre = search_results['results'].select do |result|
        result['genre_ids'].include?(genre_id)
      end
    else
      @message = "No Show Found With Name #{params[:q]}"
    end

    if params[:next_page].present?
      render json: { entries: render_to_string(partial: 'tv_shows/view_modal_card', formats: [:html]) }
    else
      render json: { entries: render_to_string(partial: 'tv_shows/view_modal_data', formats: [:html]) }
    end
  end

  def watch_season_episodes

  end

end
