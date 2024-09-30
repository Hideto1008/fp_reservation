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

  def toggle_availability
    @schedule = Schedule.find(params[:schedule_id])
    @schedule.is_available = !@schedule.is_available
    if @schedule.save
      respond_to do |format|
        format.js { render 'planners/main/toggle_availability' }
      end
    else
      respond_to do |format|
        format.js { render js: "alert('Unable to update availability.');" }
      end
    end
  end

  def create_schedule
    @schedule = Schedule.new(
      planner_id: @planner.id,
      started_at: DateTime.parse("#{params[:date]} #{params[:time]}"),
      is_available: true
    )

    if @schedule.save
      respond_to do |format|
        format.js { render 'planners/main/create_schedule' }
      end
    else
      respond_to do |format|
        format.js { render js: "alert('Unable to create schedule.');" }
      end
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
