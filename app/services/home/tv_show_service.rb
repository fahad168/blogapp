class Home::TvShowService
  def self.base_method(url)
    TmbdBaseService.api_cal(url)
  end

  def self.get_season_detail(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/tv/#{params[:season_id]}")
    base_method(url)
  end

  def self.season_videos(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/tv/#{params[:season_id]}/videos")
    base_method(url)
  end

  def self.season1(season_details)
    series_id = season_details['id']
    season_no = season_details['seasons'].first['season_number']
    url = URI("#{ENV['TMBD_BASE_URL']}/tv/#{series_id}/season/#{season_no}")
    base_method(url)
  end

  def self.episode_details(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/tv/#{params[:seriesId]}/season/#{params[:seasonNo]}")
    base_method(url)
  end

  def self.popular_shows
    url = URI("#{ENV['TMBD_BASE_URL']}/#{ENV['TMBD_DISCOVER_TV']}?first_air_date_year=#{Date.today.year}&sort_by=vote_count.desc")
    base_method(url)
  end

  def self.trending_shows
    url = URI("#{ENV['TMBD_BASE_URL']}/trending/tv/day")
    base_method(url)
  end

  def self.action_adventure
    with_genre_ids = TvGenre.where(genre_name: 'Action & Adventure').pluck(:genre_id)
    # without_genre_ids = TvGenre.where(genre_name: 'Sci-Fi & Fantasy').pluck(:genre_id)
    url = URI("#{ENV['TMBD_BASE_URL']}/discover/tv?sort_by=vote_count.desc&with_genres=#{with_genre_ids.join(',')}")
    base_method(url)
  end

  def self.sci_fi_fantasy
    with_genre_ids = TvGenre.where(genre_name: 'Sci-Fi & Fantasy').pluck(:genre_id)
    # without_genre_ids = TvGenre.where(genre_name: 'Action & Adventure').pluck(:genre_id)
    url = URI("#{ENV['TMBD_BASE_URL']}/discover/tv?sort_by=popularity.desc&with_genres=#{with_genre_ids.join(',')}")
    base_method(url)
  end

  def self.comedy
    with_genre_ids = TvGenre.where(genre_name: 'Comedy').pluck(:genre_id)
    without_genre_ids = TvGenre.where.not(genre_name: 'Comedy').pluck(:genre_id)
    url = URI("#{ENV['TMBD_BASE_URL']}/discover/tv?sort_by=popularity.desc&with_genres=#{with_genre_ids.join(',')}")
    base_method(url)
  end

  def self.specifics_genres(params, genre_ids)
    # genre_ids = params[:genre_ids].is_a?(Array) ? params[:genre_ids].join(',') : JSON.parse(params[:genre_ids]).join(',')
    # without_genre_ids = TvGenre.where.not(genre_id: params[:genre_ids].is_a?(Array) ? params[:genre_ids] : JSON.parse(params[:genre_ids])).pluck(:genre_id)
    # previous_year = Date.today.year - 2
    url = URI("#{ENV['TMBD_BASE_URL']}/discover/tv?sort_by=popularity.desc&with_genres=#{genre_ids}#{params[:next_page].present? ? "&page=#{params[:next_page]}" : ''}")
    base_method(url)
  end

  def self.get_genre_shows(name)
    with_genre_ids = TvGenre.where(genre_name: name).pluck(:genre_id)
    # without_genre_ids = TvGenre.where.not(genre_name: name).pluck(:genre_id)
    url = URI("#{ENV['TMBD_BASE_URL']}/discover/tv?with_genres=#{with_genre_ids.join(',')}")
    base_method(url)
  end

  def self.search_show(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/search/tv?query=#{params[:q]}#{params[:next_page].present? ? "&page=#{params[:next_page]}" : ''}")
    base_method(url)
  end
end
