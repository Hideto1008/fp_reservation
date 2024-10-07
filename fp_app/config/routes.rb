Rails.application.routes.draw do
  root "homepages#index"

  get "planners/:id/mypage", to: "planners/mypages#mypage", as: "planners_mypage"
  get "planners/:id/edit_planner_info", to: "planners/mypages#edit_planner_info", as: "edit_planner_info"
  patch "planners/:id/update_info", to: "planners/mypages#update_planner_info", as: "update_planner_info"

  get "planners/:id/schedule", to: "planners/schedules#schedule", as: "planners_schedule"
  post "planners/:id/schedules", to: "planners/schedules#create_schedule", as: "create_schedule"
  patch "planners/:id/schedules/:schedule_id/update_schedule", to: "planners/schedules#update_schedule", as: "update_schedule"

  get "users/:id/mypage", to: "users/mypages#mypage", as: "users_mypage"
  get "users/:id/edit_user_info", to: "users/mypages#edit_user_info", as: "edit_user_info"
  patch "users/:id/update_info", to: "users/mypages#update_user_info", as: "update_user_info"

  get "users/:id/reservation", to: "users/reservation#index", as: "reservation"
  get "users/:id/planners_list", to: "users/planners_info#list", as: "planners_list"
  get "users/:id/planners/:planner_id", to: "users/planners_info#detail", as: "planner"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_for :planners, path: "planners", controllers: {
    sessions: "planners/sessions",
    registrations: "planners/registrations"
  }
end
