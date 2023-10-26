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

end
