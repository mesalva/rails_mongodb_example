Rails.application.routes.draw do
  resources :paths
  #get 'test_mq/test'

  resources :user_rankings
  resources :users
  resources :posts
  get  "*all" => 'user_rankings#path_index'
  post "*all" => 'user_rankings#path_create'
end
