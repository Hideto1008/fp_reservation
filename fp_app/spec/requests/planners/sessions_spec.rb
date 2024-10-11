require 'rails_helper'

RSpec.describe Planners::SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:planner) { create(:planner) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:planner]
    sign_in planner
  end

  describe 'POST #create' do
    it 'redirects to /hello after login as planner' do
      post :create, params: { planner: { email: planner.email, password: planner.password } }
      expect(response).to redirect_to('/hello')
    end
  end
end
