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
  resources :blogs do
    collection do
      post :blog_details
      get :suggestions
    end
  end
  resources :draft do
    collection do
      post :draft_details
    end
  end

  resources :stores

  get "/profile", to: "profile#index"
  patch "/profile", to: "profile#update"
  get "/states", to: "profile#states"
  get "/cities", to: "profile#cities"
  get "/country_select", to: "profile#country_select"
end
