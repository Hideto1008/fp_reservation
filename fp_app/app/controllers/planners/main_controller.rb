class Planners::MainController < ApplicationController
  before_action :authenticate_planner!
  before_action :correct_planner

  def mypage
    @planner = Planner.find(params[:id])
    @appointments = Appointment.where(planner_id: @planner.id)
  end

  def schedule
    @planner = Planner.find(params[:id])
    @schedules = Schedule.where(planner_id: @planner.id)
  end

  def edit_schedule
    @planner = Planner.find(params[:id])
    @schedules = Schedule.where(planner_id: @planner.id)
  end

  def update_schedule
    @planner = Planner.find(params[:id])
    @schedules = Schedule.where(planner_id: @planner.id)
    @schedules.each do |schedule|
      schedule.update(is_available: params[:schedule]["#{schedule.id}"])
    end
    redirect_to planners_schedule_path(@planner)
  end

  def toggle_availability
    @schedule = Schedule.find(params[:id])
    @schedule.update(is_available: !@schedule.is_available)

    respond_to do |format|
      format.json { render json: { is_available: @schedule.is_available } }
    end
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
