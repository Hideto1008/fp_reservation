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
      get planners_list_path(user.id)
      planners.each do |planner|
        expect(response.body).to include(planner.name)
        expect(response.body).to include(planner.icon_path)
        expect(response.body).to include("Reserve")
      end
    end

    it "redirects if user is not logged in" do
      sign_out user
      get planners_list_path(user.id)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects if the user is not the correct user" do
      get planners_list_path(other_user.id)
      expect(response).to redirect_to(root_path)
    end
  end
end
