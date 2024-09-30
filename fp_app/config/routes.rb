Rails.application.routes.draw do
  root "homepages#index"
  get "hello", to: "hello_world#index"
  get "planners/:id/mypage", to: "planners/main#mypage", as: "planners_mypage"
  get "planners/:id/edit_planner_info", to: "planners/main#edit_planner_info", as: "edit_planner_info"
  patch "planners/:id/update_info", to: "planners/main#update_planner_info", as: "update_planner_info"
  get "planners/:id/schedule", to: "planners/main#schedule", as: "planners_schedule"
  patch "planners/:id/schedules/:schedule_id/toggle_availability", to: "planners/main#toggle_availability", as: "toggle_availability"
  post "planners/:id/schedules/create", to: "planners/main#create_schedule", as: "create_schedule"


  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_for :planners, path: "planners", controllers: {
    sessions: 'planners/sessions',
    registrations: 'planners/registrations'
  }
end
