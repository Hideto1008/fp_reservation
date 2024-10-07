require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers
  EMAIL = "test_user@example.com"

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    it 'redirects to /users/:id/mypage after user sign up' do
      user_params = {
        user: {
          email: EMAIL,
          password: 'password',
          password_confirmation: 'password'
        }
      }

      post :create, params: user_params

      user = User.find_by(email: EMAIL)
      expect(user).to be_present

      expect(response).to redirect_to(users_mypage_path(user))
    end
  end
end
