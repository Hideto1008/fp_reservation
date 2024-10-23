class AppointmentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :correct_user, only: %i[create]

  def create
    schedule = Schedule.find(params[:schedule_id])
    @appointment = Appointment.new(
      user_id: current_user.id,
      planner_id: params[:planner_id],
      schedule_id: params[:schedule_id],
      reserved_at: schedule.started_at,
      status: "reserved"
    )
    if @appointment.save
      redirect_to user_path(current_user), notice: "Appointment created successfully."
    else
      redirect_to planner_path(params[:planner_id]), alert: "Unable to create appointment."
    end
  end

  private
  def correct_user
    @user = User.find_by(id: params[:user_id])
    if @user.nil? || @user != current_user
      redirect_to root_path, alert: "You are not authorized"
    end
  end
end
