Rails.application.routes.draw do
  root "homepages#index"
  get "hello", to: "hello_world#index"
  get "planners/:id/mypage", to: "planners/planner#mypage", as: "planners_mypage"
  get "planners/:id/edit_planner_info", to: "planners/planner#edit_planner_info", as: "edit_planner_info"
  patch "planners/:id/update_info", to: "planners/planner#update_planner_info", as: "update_planner_info"
  get "planners/:id/schedule", to: "planners/planner#schedule", as: "planners_schedule"
  post "planners/:id/schedules/", to: "planners/planner#create_schedule", as: "create_schedule"
  patch "planners/:id/schedules/:schedule_id/update_schedule", to: "planners/planner#update_schedule", as: "update_schedule"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_for :planners, path: "planners", controllers: {
    sessions: "planners/sessions",
    registrations: "planners/registrations"
  }
end
