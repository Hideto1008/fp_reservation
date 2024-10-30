require 'rails_helper'

RSpec.describe Planners::SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers  # Controllerヘルパーを使う

  let(:planner) { create(:planner) }
  let(:user) { create(:user) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:planner]  # Deviseのマッピング設定
  end

  describe 'POST #create' do
    it 'redirects to /planners/:id/ after planner login' do
      # プランナーのログイン用のパラメータ
      login_params = {
        planner: {
          email: planner.email,
          password: planner.password
        }
      }

      # プランナーのログインリクエストを送信
      post :create, params: login_params

      # プランナーがログインしていることを確認
      expect(controller.planner_signed_in?).to be_truthy

      # リダイレクト先が正しいか確認
      expect(response).to redirect_to(planner_path(planner))
    end
  end

  describe "Planner login when user is already logged in" do
    before do
      sign_in user  # ユーザーがログインした状態にする
      @request.env["devise.mapping"] = Devise.mappings[:planner]  # プランナーのマッピング
    end

    it "logs out the user when the planner logs in" do
      # プランナーのログイン用のパラメータ
      login_params = {
        planner: {
          email: planner.email,
          password: planner.password
        }
      }

      # プランナーのログインリクエストを送信
      post :create, params: login_params

      # ユーザーがログアウトされていることを確認
      expect(controller.user_signed_in?).to be_falsey

      # プランナーがログインしていることを確認
      expect(controller.planner_signed_in?).to be_truthy
    end
  end
end
