class Planners::MainController < ApplicationController
  before_action :authenticate_planner!
  before_action :correct_planner

  def mypage
    @appointments = Appointment.where(planner_id: @planner.id)
  end

  def schedule
  end

  # 編集フォームを表示するためのアクション
  def edit_planner_info
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('planner_info', partial: 'planners/main/edit_info', locals: { planner: @planner })
      end
      format.html { redirect_to planners_mypage_path(@planner) }
    end
  end

  # 更新処理を行うアクション
  def update_info
    if @planner.update(planner_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('planner_info', partial: 'planners/main/show_info', locals: { planner: @planner })
        end
        format.html { redirect_to planners_mypage_path(@planner), notice: 'Information updated successfully.' }
      end
    else
      render :mypage
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
