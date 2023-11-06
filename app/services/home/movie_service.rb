class Home::MovieService
  def self.base_method(url)
    TmbdBaseService.api_cal(url)
  end

  def self.movie_details(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/movie/#{params[:movie_id]}?append_to_response=credits")
    base_method(url)
  end

  def self.movie_videos(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/movie/#{params[:movie_id]}/videos")
    base_method(url)
  end

  def self.similar_movies(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/movie/#{params[:movie_id]}/similar")
    base_method(url)
  end

  def self.action_adventure
    with_genre_ids = Genre.where(genre_name: %w[Action Adventure]).pluck(:genre_id)
    # without_genre_ids = Genre.where.not(genre_name: %w[Action Adventure]).pluck(:genre_id)
    url = URI("#{ENV['TMBD_BASE_URL']}/discover/movie?sort_by=vote_count.desc&with_genres=#{with_genre_ids.join(',')}")
    base_method(url)
  end

  def self.specifics_genres(params, genre_ids)
    # genre_ids = params[:genre_ids].is_a?(Array) ? params[:genre_ids].join(',') : JSON.parse(params[:genre_ids]).join(',')
    # without_genre_ids = Genre.where.not(genre_id: params[:key].present? ? JSON.parse(params[:genre_ids]) : params[:genre_ids]).pluck(:genre_id)
    # previous_year = Date.today.year - 2
    url = URI("#{ENV['TMBD_BASE_URL']}/discover/movie?sort_by=popularity.desc&with_genres=#{genre_ids}#{params[:next_page].present? ? "&page=#{params[:next_page]}" : ''}")
    base_method(url)
  end

  def self.trending
    url = URI("#{ENV['TMBD_BASE_URL']}/trending/movie/day")
    base_method(url)
  end

  def self.fantasy
    with_genre_ids = Genre.where(genre_name: 'Fantasy').pluck(:genre_id)
    # without_genre_ids = Genre.where.not(genre_name: 'Fantasy').pluck(:genre_id)
    url = URI("#{ENV['TMBD_BASE_URL']}/discover/movie?sort_by=vote_count.desc&with_genres=#{with_genre_ids.join(',')}")
    base_method(url)
  end

  def self.horror
    with_genre_ids = Genre.where(genre_name: 'Horror').pluck(:genre_id)
    # without_genre_ids = Genre.where.not(genre_name: 'Horror').pluck(:genre_id)
    url = URI("#{ENV['TMBD_BASE_URL']}/discover/movie?sort_by=vote_count.desc&with_genres=#{with_genre_ids.join(',')}")
    base_method(url)
  end

  def self.get_genre_movies(name)
    with_genre_ids = Genre.where(genre_name: name).pluck(:genre_id)
    # without_genre_ids = Genre.where.not(genre_name: name).pluck(:genre_id)
    url = URI("#{ENV['TMBD_BASE_URL']}/discover/movie?sort_by=vote_count.desc&with_genres=#{with_genre_ids.join(',')}")
    base_method(url)
  end

  def self.upcoming
    url = URI("#{ENV['TMBD_BASE_URL']}/movie/upcoming")
    base_method(url)
  end

  def self.search_movie(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/search/movie?query=#{params[:q]}#{params[:next_page].present? ? "&page=#{params[:next_page]}" : ''}")
    base_method(url)
  end
end
