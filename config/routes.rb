Rails.application.routes.draw do
  resources :products 
  resources :taxons , only: %i[ show index]
  resources :users
  scope "(:locale)", locale: /en|vi/ do
    devise_scope :user  do
      get "user/signin" => "devise/sessions#new"
      post "user/signin" => "devise/sessions#create"
      delete "user/signout" => "devise/sessions#destroy"
    end

    namespace :admin do
      resources :posts 
      resources :users
      get '/', to: 'dashboards#index'
      concern :paginatable do
        get '(page/:page)', action: :index, on: :collection, as: ''
      end
      resources :products do
            resources :variants 
        end
       
      resources :taxons , concerns: :paginatable
      post '/csv/create_post', to: 'csv#create_post'
      post '/csv/create_product', to: 'csv#create_product'
      # resources :variants 
    end
    root "homes#index"
    resources :posts 
  end
  devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register' }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
