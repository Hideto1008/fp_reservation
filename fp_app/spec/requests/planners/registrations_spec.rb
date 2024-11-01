require 'rails_helper'

RSpec.describe Planners::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  EMAIL = "test_planner@example.com"
  PASSWORD = "password"

  let(:user) { create(:user) }  # ユーザーを作成

  before do
    # Deviseのマッピングを設定
    @request.env["devise.mapping"] = Devise.mappings[:planner]
  end

  describe 'POST #create' do
    it 'redirects to /planners/:id after planner sign up' do
      planner_params = {
        planner: {
          email: EMAIL,
          password: PASSWORD,
          password_confirmation: PASSWORD
        }
      }

      # サインアップのリクエストを送信
      post :create, params: planner_params

      # Plannerが作成されていることを確認
      planner = Planner.find_by(email: EMAIL)
      expect(planner).to be_present  # 確認のため

      # リダイレクト先が正しいか確認
      expect(response).to redirect_to(planner_path(planner))
    end

    it 'logs out the user if user is logged in' do
      # ユーザーを先にログインさせる
      sign_in user

      planner_params = {
        planner: {
          email: EMAIL,
          password: PASSWORD,
          password_confirmation: PASSWORD
        }
      }

      # プランナーのサインアップリクエストを送信
      post :create, params: planner_params

      # プランナーが作成されていることを確認
      planner = Planner.find_by(email: EMAIL)
      expect(planner).to be_present

      # ユーザーがログアウトされていることを確認
      expect(controller.user_signed_in?).to be_falsey

      # プランナーがログインしていることを確認
      expect(controller.planner_signed_in?).to be_truthy

      # リダイレクト先が正しいか確認
      expect(response).to redirect_to(planner_path(planner))
    end
  end
end
