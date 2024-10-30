require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  EMAIL = "test_user@example.com"
  PASSWORD = "password"

  let(:planner) { create(:planner) }  # プランナーを作成

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]  # Deviseのマッピング設定
  end

  describe 'POST #create' do
    it 'redirects to /users/:id after user sign up' do
      user_params = {
        user: {
          email: EMAIL,
          password: PASSWORD,
          password_confirmation: PASSWORD
        }
      }

      # ユーザーの登録リクエストを送信
      post :create, params: user_params

      # ユーザーが作成されていることを確認
      user = User.find_by(email: EMAIL)
      expect(user).to be_present

      # リダイレクト先が正しいか確認
      expect(response).to redirect_to(user_path(user))
    end

    it 'logs out the planner if planner is logged in' do
      # プランナーを先にログインさせる
      sign_in planner

      user_params = {
        user: {
          email: EMAIL,
          password: PASSWORD,
          password_confirmation: PASSWORD
        }
      }

      # ユーザーの登録リクエストを送信
      post :create, params: user_params

      # ユーザーが作成されていることを確認
      user = User.find_by(email: EMAIL)
      expect(user).to be_present

      # プランナーがログアウトされていることを確認
      expect(controller.planner_signed_in?).to be_falsey

      # ユーザーがログインしていることを確認
      expect(controller.user_signed_in?).to be_truthy

      # リダイレクト先が正しいか確認
      expect(response).to redirect_to(user_path(user))
    end
  end
end
