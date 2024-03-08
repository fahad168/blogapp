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
  resource :blogs do
    collection do
      post :blog_details
    end
  end
end
