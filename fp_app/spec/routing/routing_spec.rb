require 'rails_helper'

RSpec.describe 'Routing', type: :routing do
  # Root path
  it 'routes root to homepages#index' do
    expect(get: '/').to route_to(
      controller: 'homepages',
      action: 'index'
    )
  end

  # Devise Users routes
  it 'routes /users/sign_in to users/sessions#new' do
    expect(get: '/users/sign_in').to route_to(
      controller: 'users/sessions',
      action: 'new'
    )
  end

  it 'routes /users/sign_up to users/registrations#new' do
    expect(get: '/users/sign_up').to route_to(
      controller: 'users/registrations',
      action: 'new'
    )
  end

  # Devise Planners routes
  it 'routes /planners/sign_in to planners/sessions#new' do
    expect(get: '/planners/sign_in').to route_to(
      controller: 'planners/sessions',
      action: 'new'
    )
  end

  it 'routes /planners/sign_up to planners/registrations#new' do
    expect(get: '/planners/sign_up').to route_to(
      controller: 'planners/registrations',
      action: 'new'
    )
  end

  # Planners routes
  it 'routes /planners/:id/mypage to planners/main#mypage' do
    expect(get: '/planners/1/mypage').to route_to(
      controller: 'planners/main',
      action: 'mypage',
      id: '1'
    )
  end

  it 'routes /planners/:id/edit_planner_info to planners/main#edit_planner_info' do
    expect(get: '/planners/1/edit_planner_info').to route_to(
      controller: 'planners/main',
      action: 'edit_planner_info',
      id: '1'
    )
  end

  it 'routes /planners/:id/update_info to planners/main#update_planner_info' do
    expect(patch: '/planners/1/update_info').to route_to(
      controller: 'planners/main',
      action: 'update_planner_info',
      id: '1'
    )
  end
end
