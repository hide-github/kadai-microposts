Rails.application.routes.draw do
  #トップページ用
  root to: 'toppages#index'
  
  #ログイン用
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  #その他
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create]
  
  #Micropost用
  resources :microposts, only: [:create, :destroy]
  
end
