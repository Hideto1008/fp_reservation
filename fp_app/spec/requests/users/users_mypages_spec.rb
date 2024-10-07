require 'rails_helper'

RSpec.describe "Users::MypagesController", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  before do
    sign_in user
  end

  describe "GET #mypage" do
    it "returns http success for the correct user" do
      get users_mypage_path(user.id)
      expect(response).to have_http_status(200)
      expect(assigns(:user)).to eq(user)
    end

    it "redirects to root for a different user" do
      get users_mypage_path(other_user.id)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET edit_user_info" do
    it "returns http success for the correct user" do
      get edit_user_info_path(user.id)
      expect(response).to have_http_status(200)
      expect(assigns(:user)).to eq(user)
      expect(response.body).to include("Edit User Information")
    end

    it "redirects to root for a different user" do
      get edit_user_info_path(other_user.id)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PATCH update_user_info" do
    it "updates the user information successfully" do
      patch update_user_info_path(user.id), params: { user: { name: "Updated Name", icon_path: "new_path.png" } }
      expect(response).to redirect_to(users_mypage_path(user))
      follow_redirect!
      expect(response.body).to include("Information updated successfully.")
      user.reload
      expect(user.name).to eq("Updated Name")
      expect(user.icon_path).to eq("new_path.png")
    end

    it "redirects to root for a different user" do
      patch update_user_info_path(other_user.id), params: { user: { name: "Updated Name" } }
      expect(response).to redirect_to(root_path)
    end
  end
end
