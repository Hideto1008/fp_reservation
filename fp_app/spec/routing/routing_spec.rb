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
  it 'routes /planners/:id/mypage to planners/mypages#mypage' do
    expect(get: '/planners/1').to route_to(
      controller: 'planners',
      action: 'show',
      id: '1'
    )
  end

  it 'routes /planners/:id/edit to planners#edit' do
    expect(get: '/planners/1/edit').to route_to(
      controller: 'planners',
      action: 'edit',
      id: '1'
    )
  end

  it 'routes /planners/:id to planners#update' do
    expect(patch: '/planners/1').to route_to(
      controller: 'planners',
      action: 'update',
      id: '1'
    )
  end

  # Planners schedule routes
  it 'routes GET /planners/:id/schedule to planners/schedules#index' do
    expect(get: '/planners/1/schedules').to route_to(
      controller: 'planners/schedules',
      action: 'index',
      planner_id: '1'
    )
  end

  it 'routes POST /planners/:id/schedules to planners/schedules#create' do
    expect(post: '/planners/1/schedules').to route_to(
      controller: 'planners/schedules',
      action: 'create',
      planner_id: '1'
    )
  end

  it 'routes PATCH /planners/:id/schedules/:schedule_id/ to planners/schedules#update' do
    expect(patch: '/planners/1/schedules/2').to route_to(
      controller: 'planners/schedules',
      action: 'update',
      planner_id: '1',
      id: '2'
    )
  end

  it 'routes GET /users/:id/mypage to users/mypages#mypage' do
    expect(get: '/users/1/mypage').to route_to(
      controller: 'users/mypages',
      action: 'mypage',
      id: '1'
    )
  end

  it 'routes GET /users/:id/edit_user_info to users/mypages#edit_user_info' do
    expect(get: '/users/1/edit_user_info').to route_to(
      controller: 'users/mypages',
      action: 'edit_user_info',
      id: '1'
    )
  end

  it 'routes PATCH /users/:id/update_info to users/mypages#update_user_info' do
    expect(patch: '/users/1/update_info').to route_to(
      controller: 'users/mypages',
      action: 'update_user_info',
      id: '1'
    )
  end
end
