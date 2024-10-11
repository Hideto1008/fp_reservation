class Planners::SchedulesController < ApplicationController
  before_action :authenticate_planner!
  before_action :correct_planner

  def index
    @planner = Planner.find(params[:planner_id])
    @schedules = @planner.schedules
  end

  def update
    @schedule = Schedule.find(params[:id])
    @schedule.is_available = !@schedule.is_available
    if @schedule.save
      respond_to do |format|
        format.js { render "planners/schedules/update_schedule" }
      end
    else
      respond_to do |format|
        format.js { render js: "alert('Unable to update availability.');" }
      end
    end
  end

  def create
    @schedule = Schedule.new(
      planner_id: @planner.id,
      started_at: DateTime.parse("#{params[:date]} #{params[:time]}"),
      is_available: true
    )
    if @schedule.save
      respond_to do |format|
        format.js { render "planners/schedules/create_schedule" }
      end
    else
      respond_to do |format|
        format.js { render js: "alert('Unable to create schedule.');" }
      end
    end
  end

  private

  def correct_planner
    @planner = Planner.find_by(id: params[:planner_id])
    if @planner.nil? || @planner != current_planner
      redirect_to root_path
    end
  end

  def planner_params
    params.require(:planner).permit(:name, :icon_path, :introduction)
  end
end
