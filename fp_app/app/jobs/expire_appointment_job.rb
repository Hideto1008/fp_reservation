# app/jobs/expire_appointment_job.rb
class ExpireAppointmentJob < ApplicationJob
  queue_as :default

  def perform(appointment_id)
    appointment = Appointment.find(appointment_id)

    appointment.update!(status: "expired")
  end
end
