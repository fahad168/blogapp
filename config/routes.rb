Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }, skip: :registrations
  devise_scope :user do
    get '/users/sign_up' => 'registrations#new', as: :new_user_registration
    post '/users/sign_up' => 'registrations#create', as: :user_registration
    post '/users/google_onetap_callback', to: 'omniauth_callbacks#google_onetap', as: :google_onetap_callback
  end

  get '/education_dataset', to: proc { [200, {}, [File.read(Rails.root.join('public', 'assets', 'educational_dataset.csv'))]] }
  get '/majors_degrees', to: proc { [200, {}, [File.read(Rails.root.join('public', 'assets', 'majors-list.csv'))]] }
  get '/languages', to: proc { [200, {}, [File.read(Rails.root.join('public', 'assets', 'languages.csv'))]] }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'home#index'
  resources :blogs do
    collection do
      post :blog_details
      get :suggestions
      get '/:id/like', to: "blogs#like"
    end
  end
  resources :draft do
    collection do
      post :draft_details
      get :bulk_delete
    end
  end
  resources :comments do
    collection do
      post :reactions
    end
  end
  resources :profile do
    collection do
      get :blogger_profile
      post :blogger_profile_edit
      post :add_education
      post :delete_education
      post :add_project
      post :delete_project
    end
  end
  resources :my_blogs do
    collection do
      get :bulk_delete
    end
  end
  resources :conversion, only: :index do
    collection do
      post :size_convert
    end
  end
end
