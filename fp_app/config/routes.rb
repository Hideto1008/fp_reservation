Rails.application.routes.draw do
  root "homepages#index"
  get "hello", to: "hello_world#index"

  resources :planners, only: [] do
    member do
      get 'mypage', to: 'planners/main#mypage'
      get 'schedule', to: 'planners/main#schedule'
      get 'edit_info', to: 'planners/main#edit_planner_info'
      patch 'update_info', to: 'planners/main#update_planner_info'
    end
  end

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_for :planners, path: "planners", controllers: {
    sessions: "planners/sessions",
    registrations: "planners/registrations"
  }
end
