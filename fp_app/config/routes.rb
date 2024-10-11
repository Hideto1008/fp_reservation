Rails.application.routes.draw do
  root "homepages#index"
  get "hello", to: "hello_world#index"
  # get "planners/:id/mypage", to: "planners/mypages#mypage", as: "planners_mypage"
  # get "planners/:id/edit_planner_info", to: "planners/mypages#edit_planner_info", as: "edit_planner_info"
  # patch "planners/:id/update_info", to: "planners/mypages#update_planner_info", as: "update_planner_info"
  # get "planners/:id/schedule", to: "planners/schedules#schedule", as: "planners_schedule"
  # post "planners/:id/schedules", to: "planners/schedules#create_schedule", as: "create_schedule"
  # patch "planners/:id/schedules/:schedule_id/update_schedule", to: "planners/schedules#update_schedule", as: "update_schedule"

  devise_for :planners, path: "planners", controllers: {
    sessions: "planners/sessions",
    registrations: "planners/registrations"
  }

  resources :planners, only: [ :show, :edit, :update ] do
    resources :schedules, only: [ :index, :create, :update ], controller: "planners/schedules"
  end


  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
end
