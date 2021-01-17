Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'pages#index'
  get 'book', to: 'pages#book'
  get 'help', to:'pages#help'
  get 'hakucho', to: 'birds#hakucho'
  get 'kosagi', to: 'birds#kosagi'
  get 'oshidori', to: 'birds#oshidori'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :users
  resources :posts, only: %i(index new create show destroy) do
    resources :photos, only: %i(create)
    resources :likes, only: %i(create destroy)
    resources :comments, only: %i(create destroy)
  end
end
