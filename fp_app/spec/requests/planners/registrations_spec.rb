require 'rails_helper'

RSpec.describe Planners::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  EMAIL = "test_planner@example.com"

  before do
    # Deviseのマッピングを設定
    @request.env["devise.mapping"] = Devise.mappings[:planner]
  end

  describe 'POST #create' do
    it 'redirects to /hello after planner sign up' do
      planner_params = {
        planner: {
          email: EMAIL,
          password: 'password',
          password_confirmation: 'password'
        }
      }
      post :create, params: planner_params
      expect(response).to redirect_to('/hello')
    end
  end
end
