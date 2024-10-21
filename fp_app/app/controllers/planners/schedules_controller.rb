class Planners::SchedulesController < ApplicationController
  before_action :authenticate_planner!, only: [ :update, :create ]
  before_action :correct_planner, only: [ :update, :create ]

  def index
    @planner = Planner.find(params[:planner_id])
    @schedules = @planner.schedules

    if planner_signed_in? && current_planner == @planner
      render :index_for_planner
    elsif user_signed_in?
      @planners = Planner.all
      render :index_for_user
    else
      redirect_to root_path, alert: "You are not authorized to access this page"
    end
  end

  def update
    @schedule = Schedule.find(params[:id])
    @schedule.is_available = params[:is_available]
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
    @schedule.save
    if @schedule.save
      respond_to do |format|
        format.js { render "planners/schedules/update_schedule" }
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
