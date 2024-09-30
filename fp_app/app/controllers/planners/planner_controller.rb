class Planners::PlannerController < ApplicationController
  before_action :authenticate_planner!
  before_action :correct_planner

  def mypage
    @planner = Planner.find(params[:id])
    @appointments = Appointment.where(planner_id: @planner.id)
  end

  def edit_planner_info
    @planner = Planner.find(params[:id])
  end

  def update_planner_info
    @planner = Planner.find(params[:id])
    if @planner.update(planner_params)
      redirect_to planners_mypage_path(@planner), notice: "Information updated successfully."
    else
      render :edit_planner_info
    end
  end

  private

  def correct_planner
    @planner = Planner.find(params[:id])
    if @planner != current_planner
      redirect_to root_path
    end
  end

  def planner_params
    params.require(:planner).permit(:name, :icon_path, :introduction)
  end
end
