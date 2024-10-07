class Users::PlannersInfoController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def list
    @planners = Planner.all
    @user = User.find(params[:id])
  end

  def detail
    @planner = Planner.find(params[:planner_id])
  end

  private

  def correct_user
    @user = User.find_by(id: params[:id])
    if @user.nil? || @user != current_user
      redirect_to root_path
    end
  end
end
