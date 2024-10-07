class Users::PlannersInfoController < ApplicationController
    def list
        @planners = Planner.all
        @user = User.find(params[:id])
    end

    def detail
        @planner = Planner.find(params[:planner_id])
        @user = User.find(params[:id])
    end

end
