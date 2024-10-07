Rails.application.routes.draw do
  root "homepages#index"
  get 'hello', to: 'hello_world#index'

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_for :planners, path: "planners", controllers: {
    sessions: 'planners/sessions',
    registrations: 'planners/registrations'
  }
end
