class AppointmentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :correct_user, only: %i[create]

  def create
    ActiveRecord::Base.transaction do
      @appointment = Appointment.new(
        user_id: params[:user_id],
        planner_id: params[:planner_id],
        schedule_id: params[:schedule_id],
        reserved_at: params[:reserved_at],
        status: "reserved"
      )

      unless @appointment.save
        raise ActiveRecord::Rollback, "Failed to create appointment"
      end

      @schedule = Schedule.find(params[:schedule_id])
      @schedule.update!(is_available: !@schedule.is_available)
    end

    redirect_to user_path(current_user), notice: "Appointment created successfully."
  rescue => e
    redirect_to planner_path(params[:planner_id]), alert: "Unable to create appointment: #{e.message}"
  end

  private
  def correct_user
    @user = User.find_by(id: params[:user_id])
    if @user.nil? || @user != current_user
      redirect_to root_path, alert: "You are not authorized"
    end
  end
end
