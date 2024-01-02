module ApplicationHelper

  def generate_structured_data
    case controller_name
    when 'movies'
      movie_structured_data(@popular_movie) if defined?(@popular_movie)
    when 'tv_shows'
      tv_series_structured_data(@popular_seasons) if defined?(@popular_seasons)
    when 'home'
      movie_structured_data(@popular) if defined?(@popular)
    else
      # Default or handle other cases
    end
  end

  def movie_structured_data(popular_movies)
    movie = popular_movies["results"].shuffle.first
    content_tag(:script, type: 'application/ld+json') do
      raw({
            "@context": "https://schema.org",
            "@type": "VideoObject",
            "name": movie['original_title'],
            "description": movie['overview'],
            "thumbnailUrl": "#{ENV['TMBD_IMAGE_URL']}/w780/#{movie['poster_path'].present? ? movie['poster_path'] : movie['backdrop_path']}",
            "uploadDate": movie['release_date'],
            "duration": movie['runtime'].present? ? "#{movie['runtime'] / 60} h #{movie['runtime'] % 60 } m" : '',
            "contentUrl": "https://moviesapi.club/movie/#{movie['id']}",
          }.to_json)
    end
  end

  def tv_series_structured_data(popular_seasons)
    tv_series = popular_seasons["results"].shuffle.first
    content_tag(:script, type: 'application/ld+json') do
      raw({
            "@context": "https://schema.org",
            "@type": "VideoObject",
            "name": tv_series['original_name'],
            "description": tv_series['overview'],
            "thumbnailUrl": "#{ENV['TMBD_IMAGE_URL']}/w780/#{tv_series['poster_path'].present? ? tv_series['poster_path'] : tv_series['backdrop_path']}",
            "uploadDate": tv_series['first_air_date'].present? ? tv_series['first_air_date'] : '',
            "totalSeasons": tv_series['number_of_seasons'],
            "contentUrl": "https://moviesapi.club/tv/#{tv_series['id']}-1-1",
          }.to_json)
    end
  end
end
