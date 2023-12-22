class AdvanceSearchController < ApplicationController
  # before_action :authenticate_user!
  def index
    if params[:type].present?
      @results = JSON.parse(Home::AdvanceSearchService.get_search_result(params))
      if params[:type] == 'movie'
        render json: { entries: render_to_string(partial: 'advance_search/search_movies_results', formats: [:html]) }
      else
        render json: { entries: render_to_string(partial: 'advance_search/search_tv_results', formats: [:html]) }
      end
    else
      @combined_data = []
      @movies = JSON.parse(Home::AdvanceSearchService.get_index_movies(params))
      @tv_shows = JSON.parse(Home::AdvanceSearchService.get_index_tv(params))
      if @movies['results'].present? && @tv_shows['results'].present?
        @combined_data = @movies['results'] + @tv_shows['results']
        @combined_data.shuffle!
      end
      if params[:page].present?
        render json: { entries: render_to_string(partial: 'advance_search/results_without_filter', formats: [:html]) }
      end
    end
  end
end
