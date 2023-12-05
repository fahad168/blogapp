class Home::SearchService

  def initialize(params)
    @page = params[:page]
    @keyword = params[:q]
  end

  def base_method
    TmbdBaseService.api_cal(make_url)
  end

  def make_url
    case @page
    when 'home'
      URI("#{ENV['TMBD_BASE_URL']}/search/multi?query=#{@keyword}")
    when 'movies'
      URI("#{ENV['TMBD_BASE_URL']}/search/movie?query=#{@keyword}")
    else
      URI("#{ENV['TMBD_BASE_URL']}/search/tv?query=#{@keyword}")
    end
  end
end
