require 'uri'
require 'net/http'
class Home::AdvanceSearchService

  def self.base_method(url)
    TmbdBaseService.api_cal(url)
  end

  def self.get_index_movies(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/#{ENV['TMBD_DISCOVER']}?page=#{params[:page].present? ? params[:page] : 1}")
    base_method(url)
  end

  def self.get_index_tv(params)
    url = URI("#{ENV['TMBD_BASE_URL']}/#{ENV['TMBD_DISCOVER_TV']}?page=#{params[:page].present? ? params[:page] : 1}")
    base_method(url)
  end

  def self.get_search_result(params)
    temp_url = "#{ENV['TMBD_BASE_URL']}/discover/#{params[:type]}"
    if params[:genre_id].present?
      temp_url = if temp_url.include?('?')
                   "#{temp_url}&with_genres=#{params[:genre_id]}"
                 else
                   "#{temp_url}?with_genres=#{params[:genre_id]}"
                 end
    end
    if params[:language].present?
      temp_url = if temp_url.include?('?')
                   "#{temp_url}&with_original_language=#{params[:language]}"
                 else
                   "#{temp_url}?with_original_language=#{params[:language]}"
                 end
    end
    if params[:year].present?
      temp_url = if temp_url.include?('?')
                   "#{temp_url}&primary_release_year=#{params[:year]}"
                 else
                   "#{temp_url}?primary_release_year=#{params[:year]}"
                 end
    end
    if params[:sort_by].present?
      temp_url = if temp_url.include?('?')
                   "#{temp_url}&sort_by=#{params[:sort_by]}"
                 else
                   "#{temp_url}?sort_by=#{params[:sort_by]}"
                 end
    end
    if params[:page].present?
      temp_url = if temp_url.include?('?')
                   "#{temp_url}&page=#{params[:page]}"
                 else
                   "#{temp_url}?page=#{params[:page]}"
                 end
    end
    url = URI(temp_url)
    base_method(url)
  end
end
