require 'rails_helper'

RSpec.describe "Users::PlannersDetail", type: :request do
  describe "GET planners/:id" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user, email: "other@example.com") }
    let(:planner) { create(:planner) }

    before do
      sign_in user
    end

    context "when the user is logged in" do
      it "renders the detail page successfully" do
        get planner_path(id: planner.id)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show_for_user)
        expect(assigns(:planner)).to eq(planner)
        expect(response.body).to include(planner.name)
        expect(response.body).to include(planner.icon_path)
        expect(response.body).to include(planner.introduction)
        expect(response.body).to include("Reserve")
      end
    end

    context "when the user is not logged in" do
      before do
        sign_out user
      end

      it "redirects to the root path" do
        get planner_path(planner.id)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
