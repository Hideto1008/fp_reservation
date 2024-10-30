require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers  # Controllerヘルパーを使う

  let(:user) { create(:user) }
  let(:planner) { create(:planner) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]  # Deviseのマッピング設定
  end

  describe 'POST #create' do
    it 'redirects to /users/:id/ after user login' do
      # ユーザーのログイン用のパラメータ
      login_params = {
        user: {
          email: user.email,
          password: user.password
        }
      }

      # ユーザーのログインリクエストを送信
      post :create, params: login_params

      # ユーザーがログインしていることを確認
      expect(controller.user_signed_in?).to be_truthy

      # リダイレクト先が正しいか確認
      expect(response).to redirect_to(user_path(user))
    end
  end

  describe "User login when planner is already logged in" do
    before do
      sign_in planner  # プランナーがログインした状態にする
      @request.env["devise.mapping"] = Devise.mappings[:user]  # ユーザーのマッピングに戻す
    end

    it "logs out the planner when the user logs in" do
      # ユーザーのログイン用のパラメータ
      login_params = {
        user: {
          email: user.email,
          password: user.password
        }
      }

      # ユーザーのログインリクエストを送信
      post :create, params: login_params

      # プランナーがログアウトされていることを確認
      expect(controller.planner_signed_in?).to be_falsey

      # ユーザーがログインしていることを確認
      expect(controller.user_signed_in?).to be_truthy
    end
  end
end
