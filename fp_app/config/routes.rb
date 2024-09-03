Rails.application.routes.draw do
  root "hello_world#index"
  devise_for :planners
  devise_for :users
end
