require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe 'POST #create' do
    it 'redirects to /hello after login' do
      post :create, params: { user: { email: user.email, password: user.password } }
      expect(response).to redirect_to('/hello')
    end
  end
end
