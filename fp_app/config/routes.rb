Rails.application.routes.draw do
  root "homepages#index"
  get 'hello', to: 'hello_world#index'
  get 'planners/:id/mypage', to: 'planners/main#mypage', as: 'planners_mypage'
  get 'planners/:id/schedule', to: 'planners/main#schedule'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_for :planners, path: "planners", controllers: {
    sessions: 'planners/sessions',
    registrations: 'planners/registrations'
  }
end
