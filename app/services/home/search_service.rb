class Home::SearchService

  def initialize(params, user)
    @page = params[:page]
    @keyword = params[:q]
    @person_id = params[:person_id]
    @user = user
  end

  def base_method
    TmbdBaseService.api_cal(make_url)
  end

  def self.keywords_call(url)
    TmbdBaseService.api_cal(url)
  end

  def make_url
    case @page
    when 'home'
      URI("#{ENV['TMBD_BASE_URL']}/search/multi?query=#{@keyword}&include_adult=#{@user.present? ? @user.setting.adult_content : 'false'}")
    when 'movies'
      URI("#{ENV['TMBD_BASE_URL']}/search/movie?query=#{@keyword}&include_adult=#{@user.present? ? @user.setting.adult_content : 'false'}")
    else
      URI("#{ENV['TMBD_BASE_URL']}/search/tv?query=#{@keyword}&include_adult=#{@user.present? ? @user.setting.adult_content : 'false'}")
    end
  end

  def self.keywords_suggestions(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/search/keyword?query=#{params[:q]}")
    keywords_call(url)
  end
end
