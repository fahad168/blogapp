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
  get '/search_results', to: 'home#search_results'
  get '/person_detail', to: 'home#person_detail'
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
  post '/profile/update', to: 'profile#update'
  get '/albums', to: 'profile#albums'
  post '/create_album', to: 'profile#create_album'
  get '/album/:username/:album_title', to: 'profile#show_album'
  get '/album', to: 'profile#show_album_data'
  delete '/album/:id', to: 'profile#destroy'
  get '/movies_dropdown_data', to: 'profile#movies_dropdown_data'
  get '/show_dropdown_data', to: 'profile#show_dropdown_data'
  post '/cover_photo', to: 'profile#cover_photo'
  post '/profile_image', to: 'profile#profile_image'
  post '/add_movie', to: 'profile#add_movie'
  post '/add_series', to: 'profile#add_series'
  get '/followers', to: 'profile#followers'
  get '/followings', to: 'profile#followings'
  get '/explore', to: 'profile#explore'
  get '/pending_requests', to: 'profile#pending_requests'
  post '/unfollow', to: 'profile#unfollow'
  post '/unfriend', to: 'profile#unfriend'
  get '/settings', to: 'profile#settings'
  get '/update_settings', to: 'profile#update_settings'
  get '/other_albums', to: 'other_users#index'
  get '/other_user_profile', to: 'other_users#other_user_profile'
  get '/other_user_albums', to: 'other_users#other_user_albums'
  get '/other_user_followers', to: 'other_users#other_user_followers'
  get '/other_user_followings', to: 'other_users#other_user_followings'
  post '/create_following', to: 'followings#create'
  post '/cancel_following', to: 'followings#cancel'
  post '/update_request', to: 'followings#update_request'
  get '/browse', to: 'advance_search#index'
end
