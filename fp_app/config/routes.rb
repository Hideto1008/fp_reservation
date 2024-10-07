Rails.application.routes.draw do
  root "homepages#index"
  get "hello", to: "hello_world#index"
  get "planners/:id/mypage", to: "planners/main#mypage", as: "planners_mypage"
  get "planners/:id/schedule", to: "planners/main#schedule", as: "planners_schedule"
  get "planners/:id/edit_planner_info", to: "planners/main#edit_planner_info", as: "edit_planner_info"
  patch "planners/:id/update_info", to: "planners/main#update_planner_info", as: "update_planner_info"


  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_for :planners, path: "planners", controllers: {
    sessions: "planners/sessions",
    registrations: "planners/registrations"
  }
end
