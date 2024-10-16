require 'rails_helper'

RSpec.describe "UsersController", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  before do
    sign_in user
  end

  describe "GET #mypage" do
    it "returns http success for the correct user" do
      get user_path(user.id)
      expect(response).to have_http_status(200)
      expect(assigns(:user)).to eq(user)
    end

    it "redirects to root for a different user" do
      get user_path(other_user.id)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET users/:id/edit" do
    it "returns http success for the correct user" do
      get edit_user_path(user.id)
      expect(response).to have_http_status(200)
      expect(assigns(:user)).to eq(user)
      expect(response.body).to include("Edit User Information")
    end

    it "redirects to root for a different user" do
      get edit_user_path(other_user.id)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PATCH users/:id" do
    it "updates the user information successfully" do
      patch user_path(user.id), params: { user: { name: "Updated Name", icon_path: "new_path.png" } }
      expect(response).to redirect_to(user_path(user))
      follow_redirect!
      expect(response.body).to include("Information updated successfully.")
      user.reload
      expect(user.name).to eq("Updated Name")
      expect(user.icon_path).to eq("new_path.png")
    end

    it "redirects to root for a different user" do
      patch user_path(other_user.id), params: { user: { name: "Updated Name" } }
      expect(response).to redirect_to(root_path)
    end
  end
end
