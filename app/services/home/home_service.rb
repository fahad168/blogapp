require 'uri'
require 'net/http'
class Home::HomeService
  def self.base_method(url)
    TmbdBaseService.api_cal(url)
  end

  def self.now_playing(params)
    url = if params != nil && params[:next_page].present?
            URI("#{ENV['TMBD_BASE_URL']}/#{ENV['TMBD_NOW_PLAYING']}?region=US&page=#{params[:next_page]}")
          else
            URI("#{ENV['TMBD_BASE_URL']}/#{ENV['TMBD_NOW_PLAYING']}?region=US")
          end
    base_method(url)
  end

  def self.popular(params)
    url = if params != nil && params[:next_page].present?
            URI("#{ENV['TMBD_BASE_URL']}/#{ENV['TMBD_POPULAR']}?region=PK&page=#{params[:next_page]}")
          else
            URI("#{ENV['TMBD_BASE_URL']}/#{ENV['TMBD_POPULAR']}?region=PK")
          end
    base_method(url)
  end

  def self.top_rated(params)
    url = if params != nil && params[:next_page].present?
            URI("#{ENV['TMBD_BASE_URL']}/#{ENV['TMBD_TOP_RATED']}?region=PK&page=#{params[:next_page]}")
          else
            URI("#{ENV['TMBD_BASE_URL']}/#{ENV['TMBD_TOP_RATED']}?region=PK")
          end
    base_method(url)
  end

  def self.top_rated_shows(params)
    url = if params != nil && params[:next_page].present?
            URI("#{ENV['TMBD_BASE_URL']}/tv/top_rated?page=#{params[:next_page]}")
          else
            URI("#{ENV['TMBD_BASE_URL']}/tv/top_rated")
          end
    base_method(url)
  end

  def self.get_person_details(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/person/#{params[:person_id]}")
    base_method(url)
  end

  def self.get_person_data(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/person/#{params[:person_id]}/combined_credits")
    base_method(url)
  end

  def self.lollywood(params)
    url = if params != nil && params[:next_page].present?
            URI("#{ENV['TMBD_BASE_URL']}/discover/movie?page=#{params[:next_page]}&with_origin_country=PK&with_original_language=ur")
          else
            URI("#{ENV['TMBD_BASE_URL']}/discover/movie?with_origin_country=PK&with_original_language=ur")
          end
    base_method(url)
  end

  def self.trending_all
    url = URI("#{ENV['TMBD_BASE_URL']}/trending/all/week")
    base_method(url)
  end

  def self.bollywood(params)
    url = if params != nil && params[:next_page].present?
            URI("#{ENV['TMBD_BASE_URL']}/discover/movie?page=#{params[:next_page]}&with_origin_country=IN")
          else
            URI("#{ENV['TMBD_BASE_URL']}/discover/movie?with_origin_country=IN")
          end
    base_method(url)
  end
end
