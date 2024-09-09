Rails.application.routes.draw do
  root "hello_world#index"
  devise_for :users
end
