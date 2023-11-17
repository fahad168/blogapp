Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }, skip: :registrations
  devise_scope :user do
    get '/users/sign_up' => 'registrations#new', as: :new_user_registration
    post '/users/sign_up' => 'registrations#create', as: :user_registration
    post '/users/google_onetap_callback', to: 'omniauth_callbacks#google_onetap', as: :google_onetap_callback
  end
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
  get '/tv_shows', to: 'tv_shows#index'
  post '/specific_genre_shows', to: 'tv_shows#specific_genre_shows'
  get '/watch_season_episodes', to: 'tv_shows#watch_season_episodes'
  get '/profile', to: 'profile#index'
end
