class Home::ViewAllService
  def self.get_all_data(params)
    case params[:key]
    when 'playing_now'
      Home::HomeService.now_playing(params)
    when 'popular_movies'
      Home::HomeService.popular(params)
    when 'top_rated_shows'
      Home::HomeService.top_rated_shows(params)
    when 'top_rated_movies'
      Home::HomeService.top_rated(params)
    when 'lollywood'
      Home::HomeService.lollywood(params)
    when 'bollywood'
      Home::HomeService.bollywood(params)
    else
    end
  end
end
