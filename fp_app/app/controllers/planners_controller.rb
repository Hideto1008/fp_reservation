class PlannersController < ApplicationController
  before_action :authenticate_planner!, only: %i[edit update]
  before_action :authenticate_user!, only: %i[index]
  before_action :correct_planner, only: %i[edit update]
  before_action :find_planner, only: %i[show edit update]


  def index
    @planners = Planner.all
  end

  def show
    @appointments = @planner.appointments
    if current_planner != @planner && !user_signed_in?
      redirect_to root_path, alert: "You are not authorized to access this page"
    end
  end

  def edit
  end

  def update
    if @planner.update(planner_params)
      redirect_to planner_path(@planner), notice: "Information updated successfully."
    else
      render :edit
    end
  end

  private

  def correct_planner
    unless params[:id].to_i > 0
      redirect_to root_path, alert: "Invalid planner ID"
      return
    end

    @planner = Planner.find_by(id: params[:id])
    if @planner.nil? || @planner != current_planner
      redirect_to root_path, alert: "You are not authorized to access this page"
    end
  end

  def planner_params
    params.require(:planner).permit(:name, :icon_path, :introduction)
  end

  def find_planner
    @planner = Planner.find(params[:id])
  end
end
