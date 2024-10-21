class PlannersController < ApplicationController
  before_action :authenticate_planner!, only: [ :show, :edit, :update ]
  before_action :authenticate_user!, only: [ :index ]
  before_action :correct_planner, only: [ :show, :edit, :update ]

  def index
    @planners = Planner.all
  end

  def show
    @appointments = Appointment.where(planner_id: @planner.id)
  end

  def edit
  end

  def update
    if @planner.update(planner_params)
      redirect_to planner_path(@planner), notice: "Information updated successfully."
    else
      render :edit, alert: "Failed to update information."
    end
  end

  private

  def correct_planner
    @planner = Planner.find_by(id: params[:id])
    if @planner.nil? || @planner != current_planner
      redirect_to root_path, alert: "You are not authorized to access this page"
    end
  end

  def find_planner
    @planner = Planner.find(params[:id])
  end

  def planner_params
    params.require(:planner).permit(:name, :icon_path, :introduction)
  end
end
