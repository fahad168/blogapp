Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'home#index'
  get '/get_modal_data', to: 'home#get_modal_data'
  get '/get_season_details', to: 'home#get_season_data'
  post '/episodes_details', to: 'home#episodes_details'
  get '/view_all', to: 'home#view_all'
  get '/movies', to: 'movies#index'
  post '/specific_genre_movies', to: 'movies#specific_genre_movies'
end
