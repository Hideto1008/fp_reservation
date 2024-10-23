# spec/requests/planners_main_spec.rb
require 'rails_helper'

RSpec.describe "PlannersController", type: :request do
  let(:planner) { create(:planner) }
  let(:other_planner) { create(:planner, email: "other@example.com") }
  let(:user) { create(:user) }

  before do
    sign_in planner
  end

  describe "planners_index" do
    it "returns a successful response and displays all planners" do
      sign_in user
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

  describe "GET /planners/:id" do
    context "when the logged-in planner is the correct planner" do
      it "displays the mypage" do
        get planner_path(planner)
        expect(response).to have_http_status(:success)
        expect(response.body).to include(planner.name)
        expect(response.body).to include(planner.introduction)
        expect(response.body).to include(planner.icon_path)
      end
    end

    context "when accessing another planner's mypage" do
      it "redirects to the root page" do
        get planner_path(other_planner)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /planners/:id/edit" do
    context "when the logged-in user is the correct planner" do
      it "displays the edit page" do
        get edit_planner_path(planner)
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Edit Planner Information")
      end
    end

    context "when accessing another planner's edit page" do
      it "redirects to the root page" do
        get edit_planner_path(other_planner)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /planners/:id" do
    context "with valid parameters" do
      it "updates the planner info and redirects to mypage" do
        patch planner_path(planner), params: { planner: { name: "New Name", icon_path: "/new/icon/path.png", introduction: "New Introduction" } }
        expect(response).to redirect_to(planner_path(planner))
        follow_redirect!
        expect(response.body).to include("New Name")
        expect(response.body).to include("New Introduction")
        expect(response.body).to include("/new/icon/path.png")
        expect(response.body).to include("Information updated successfully.")
      end
    end

    context "when attempting to update another planner's info" do
      it "redirects to the root page" do
        patch planner_path(other_planner), params: { planner: { name: "Unauthorized Update" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /planners/sign_out" do
    it "signs out the planner and redirects to the home page" do
      delete destroy_planner_session_path
      expect(response).to redirect_to(root_path)
    end
  end
end
