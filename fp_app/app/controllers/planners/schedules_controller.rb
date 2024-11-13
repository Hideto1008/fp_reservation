class Planners::SchedulesController < ApplicationController
  before_action :authenticate_planner!, only: [ :update, :create ]
  before_action :correct_planner, only: [ :update, :create ]
  before_action :correct_planner_for_index, only: [ :index ], if: :planner_signed_in?
  ITEMS_PER_PAGE = 5

  def index
    @selected_planner = Planner.find(params[:planner_id])
    @schedules = @selected_planner.schedules

    if user_signed_in?
      @planners = Planner.page(params[:page]).per(ITEMS_PER_PAGE)

      if request.referer&.match(%r{.*/planners$}) || request.referer&.match(%r{.*/planners\?page=\d+$}) || request.referer&.match(%r{.*/planners/#{@planner.id}$})
        planner_position = Planner.order(:id).pluck(:id).index(@planner.id)
        page_number = (planner_position / 5) + 1
        if page_number != params[:page].to_i
          redirect_to planner_schedules_path(planner_id: @planner.id, page: page_number)
        end
      end
    end
  end

  def show
    @schedule = Schedule.find(params[:id])
    @planner = @schedule.planner
  end

  def update
    @schedule = Schedule.find(params[:id])
    if @schedule.appointments.exists?(status: "reserved")
      respond_to do |format|
        format.js { render js: "alert('This schedule is associated with an existing appointment and cannot be updated.');" }
      end
    else
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
  end

  def create
    @schedule = Schedule.new(
      planner_id: @planner.id,
      started_at: DateTime.parse("#{params[:date]} #{params[:time]}"),
      is_available: true
    )
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
    redirect_to root_path, alert: "You are not authorized" unless @planner == current_planner
  end

  def correct_planner_for_index
    @planner = Planner.find_by(id: params[:planner_id])
    if @planner.nil? || @planner != current_planner
      redirect_to root_path, alert: "You are not authorized to view this schedule"
    end
  end

  def planner_params
    params.require(:planner).permit(:name, :icon_path, :introduction)
  end
end
