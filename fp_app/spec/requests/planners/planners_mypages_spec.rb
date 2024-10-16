# spec/requests/planners_main_spec.rb
require 'rails_helper'

RSpec.describe "Planners::MypagesController", type: :request do
  let(:planner) { create(:planner) }
  let(:other_planner) { create(:planner, email: "other@example.com") }

  before do
    sign_in planner
  end

  describe "GET /planners/:id/mypage" do
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

  describe "GET /planners/:id/edit_planner_info" do
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

  describe "PATCH /planners/:id/update_planner_info" do
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
