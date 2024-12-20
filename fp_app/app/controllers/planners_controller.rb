class PlannersController < ApplicationController
  before_action :authenticate_planner!, only: %i[edit update]
  before_action :authenticate_user!, only: %i[index]
  before_action :correct_planner, only: %i[edit update]
  before_action :find_planner, only: %i[show edit update]
  ITEMS_PER_PAGE_FOR_INDEX = 10
  ITEMS_PER_PAGE_FOR_SHOW = 7

  def index
    search_word_params = params[:name_cont] ? { name_cont: params[:name_cont] } : nil
    search_word = Planner.ransack(search_word_params)
    searched_planners = search_word.result(distinct: true)
    case params[:sort]
    when "total_of_consultations"
      @planners = searched_planners.with_done_appointments.page(params[:page]).per(ITEMS_PER_PAGE_FOR_INDEX)
    else
      @planners = searched_planners.order(:created_at).page(params[:page]).per(ITEMS_PER_PAGE_FOR_INDEX)
    end
  end

  def show
    @appointments = @planner.appointments.order(reserved_at: :desc).page(params[:page]).per(ITEMS_PER_PAGE_FOR_SHOW)
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
