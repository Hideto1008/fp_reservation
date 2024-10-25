class AppointmentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update]
  before_action :correct_user, only: %i[create update]

  def create
    ActiveRecord::Base.transaction do
      @appointment = Appointment.new(
        user_id: params[:user_id],
        planner_id: params[:planner_id],
        schedule_id: params[:schedule_id],
        reserved_at: params[:reserved_at],
        status: "reserved"
      )

      @appointment.save!

      @schedule = Schedule.find(params[:schedule_id])
      @schedule.update!(is_available: !@schedule.is_available)
    end

    redirect_to user_path(current_user), notice: "Appointment created successfully."
  rescue => e
    logger.error "Transaction failed: #{e.message}"
    redirect_to user_path(params[:user_id]), alert: "Unable to create appointment: #{e.message}"
  end


  def update
    ActiveRecord::Base.transaction do
      @appointment = Appointment.find(params[:id])
      @appointment.status = params[:status]

      unless @appointment.save
        logger.error "Appointment save failed: #{@appointment.errors.full_messages.join(', ')}"
        raise "Failed to update appointment"
      end

      @schedule = Schedule.find(@appointment.schedule_id)
      unless @schedule.update(is_available: !@schedule.is_available)
        logger.error "Schedule update failed: #{@schedule.errors.full_messages.join(', ')}"
        raise "Failed to update schedule"
      end
    end

    redirect_to user_path(current_user), notice: "Appointment updated successfully."
  rescue => e
    logger.error "Transaction failed: #{e.message}"
    redirect_to user_path(current_user), alert: "Unable to update appointment: #{e.message}"
  end


  private

  def correct_user
    @user = User.find_by(id: params[:user_id])
    if @user.nil? || @user != current_user
      redirect_to root_path, alert: "You are not authorized"
    end
  end
end
