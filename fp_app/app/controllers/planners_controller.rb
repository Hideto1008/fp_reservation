class PlannersController < ApplicationController
  before_action :authenticate_planner!, only: [ :edit, :update ]
  before_action :authenticate_user!, only: [ :index  ]
  before_action :correct_planner, only: [ :edit, :update ]

  def index
    @planners = Planner.all
  end

  def show
    @planner = Planner.find(params[:id])

    if planner_signed_in? && current_planner == @planner
      @appointments = Appointment.where(planner_id: @planner.id)
      render :show_for_planner
    elsif user_signed_in?
      render :show_for_user
    else
      redirect_to root_path, alert: "You are not authorized to access this page"
    end
  end

  def edit
    @planner = Planner.find(params[:id])
  end

  def update
    @planner = Planner.find(params[:id])
    if @planner.update(planner_params)
      redirect_to planner_path(@planner), notice: "Information updated successfully."
    else
      render :edit
    end
  end

  private

  def correct_planner
    @planner = Planner.find_by(id: params[:id])
    if @planner.nil? || @planner != current_planner
      redirect_to root_path, alert: "You are not authorized to access this page"
    end
  end

  def planner_params
    params.require(:planner).permit(:name, :icon_path, :introduction)
  end
end
