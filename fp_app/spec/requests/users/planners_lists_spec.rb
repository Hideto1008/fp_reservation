require 'rails_helper'

RSpec.describe "PlannersInfo", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }
  let!(:planner) { create(:planner) }
  let!(:other_planner) { create(:other_planner) }

  before do
    sign_in user
  end

  describe "planners_list" do
    it "returns a successful response and displays all planners" do
      planners = [ planner, other_planner ]
      get planners_path
      planners.each do |planner|
        expect(response.body).to include(planner.name)
        expect(response.body).to include(planner.icon_path)
        expect(response.body).to include(other_planner.name)
        expect(response.body).to include(other_planner.icon_path)
        expect(response.body).to include("Reserve")
      end
    end

    it "redirects if user is not logged in" do
      sign_out user
      get planners_path(user.id)
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include("You need to sign in or sign up before continuing.")
    end
  end
end
