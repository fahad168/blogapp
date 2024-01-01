# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://moviescorn.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  add '/', :changefreq => 'daily', :priority => 0.9
  add '/movies', :changefreq => 'daily',  :priority => 0.8
  add '/tv_shows', :changefreq => 'daily',  :priority => 0.8
  add '/other_albums', :changefreq => 'daily',  :priority => 0.7
  add '/browse', :changefreq => 'daily',  :priority => 1.0
  add '/profile', :changefreq => 'daily',  :priority => 0.5
  add '/view_all?key=popular_movies', :changefreq => 'daily',  :priority => 0.8
  add '/view_all?key=playing_now', :changefreq => 'daily',  :priority => 0.8
  add '/view_all?key=lollywood&type=movies', :changefreq => 'daily',  :priority => 0.7
  add '/view_all?key=bollywood&type=movies', :changefreq => 'daily',  :priority => 0.7
  add '/view_all?key=top_rated_movies', :changefreq => 'daily',  :priority => 0.7
  add '/view_all?key=top_rated_movies', :changefreq => 'daily',  :priority => 0.7
  add '/view_all?key=top_rated_shows&type=series', :changefreq => 'daily',  :priority => 0.9
end
