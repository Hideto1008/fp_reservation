Rails.application.routes.draw do
  root "homepages#index"

  devise_for :planners, path: "planners", controllers: {
    sessions: "planners/sessions",
    registrations: "planners/registrations"
  }

  resources :planners, only: [ :index, :show, :edit, :update ] do
    resources :schedules, only: [ :index, :show, :create, :update ], controller: "planners/schedules"
  end

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :users, only: [ :show, :edit, :update ]
  resources :appointments, only: [ :create, :update ]
end
