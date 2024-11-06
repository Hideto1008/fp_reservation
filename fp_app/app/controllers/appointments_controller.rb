class AppointmentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update]
  before_action :correct_user, only: %i[create update]

  def create
    ActiveRecord::Base.transaction do
      Appointment.create!(appointment_params)

      schedule = Schedule.find(appointment_params[:schedule_id])
      schedule.update!(is_available: false)
    end

    redirect_to user_path(current_user), notice: "Appointment created successfully."
  rescue => e
    logger.error "Transaction failed: #{e.message}"
    redirect_to user_path(current_user), alert: "Unable to create appointment: #{e.message}"
  end

  def update
    ActiveRecord::Base.transaction do
      appointment = Appointment.find(params[:id])
      appointment.update!(status: params[:status])

      if appointment.status_canceled?
        schedule = Schedule.find(appointment.schedule_id)
        schedule.update!(is_available: true)
      end
    end

    redirect_to user_path(current_user), notice: "Appointment updated successfully."
  rescue => e
    logger.error "Transaction failed: #{e.message}"
    redirect_to user_path(current_user), alert: "Unable to update appointment: #{e.message}"
  end

  private

  def correct_user
    user_id = params.dig(:appointment, :user_id) || params[:user_id]
    @user = User.find_by(id: user_id)
    if @user.nil? || @user != current_user
      redirect_to root_path, alert: "You are not authorized"
    end
  end

  def appointment_params
    params.require(:appointment).permit(:user_id, :planner_id, :schedule_id, :reserved_at, :status)
  end
end
