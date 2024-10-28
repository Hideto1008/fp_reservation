# app/jobs/expire_appointment_job.rb
class ExpireAppointmentJob
  include Sidekiq::Job

  def perform(appointment_id)
    appointment = Appointment.find_by(id: appointment_id)
    return unless appointment && appointment.status == "reserved"

    appointment.update!(status: "expired")
  end
end
