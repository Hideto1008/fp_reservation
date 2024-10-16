require 'rails_helper'

RSpec.describe Planners::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers
  EMAIL = "test_planner@example.com"

  before do
    @request.env["devise.mapping"] = Devise.mappings[:planner]
  end

  describe 'POST #create' do
    it 'redirects to /planners/:id/ after planner sign up' do
      planner_params = {
        planner: {
          email: EMAIL,
          password: 'password',
          password_confirmation: 'password'
        }
      }

      # サインアップのリクエストを送信
      post :create, params: planner_params

      # Plannerが作成されていることを確認
      planner = Planner.find_by(email: EMAIL)
      expect(planner).to be_present

      # リダイレクト先が正しいか確認
      expect(response).to redirect_to(planner_path(planner))
    end
  end
end
