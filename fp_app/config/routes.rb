Rails.application.routes.draw do
  root "homepages#index"
  get "hello", to: "hello_world#index"
  get "planners/:id/mypage", to: "planners/main#mypage", as: "planners_mypage"
  get "planners/:id/edit_planner_info", to: "planners/main#edit_planner_info", as: "edit_planner_info"
  patch "planners/:id/update_info", to: "planners/main#update_planner_info", as: "update_planner_info"
  get "planners/:id/schedule", to: "planners/main#schedule", as: "planners_schedule"
  get "planners/:id/schedule/edit", to: "planners/main#edit_schedule", as: "edit_schedule"
  patch "planners/:id/schedule/update", to: "planners/main#update_schedule", as: "update_schedule"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_for :planners, path: "planners", controllers: {
    sessions: "planners/sessions",
    registrations: "planners/registrations"
  }

  resources :schedules, only: [] do
    member do
      patch :toggle_availability
    end
  end
end
