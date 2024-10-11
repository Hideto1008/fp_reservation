require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  EMAIL = "test_user@example.com"
  PASSWORD = "password"

  before do
    # Deviseのマッピングを設定
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    it 'redirects to /hello after user sign up' do
      user_params = {
        user: {
          email: EMAIL,
          password: PASSWORD,
          password_confirmation: PASSWORD
        }
      }
      post :create, params: user_params
      expect(response).to redirect_to('/hello')
    end
  end
end
