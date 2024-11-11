# app/jobs/expire_appointment_job.rb
class ExpireAppointmentJob < ApplicationJob
  queue_as :default

  def perform
    cutoff_time = Time.current - 1.hour
    Appointment.where(status: "reserved").where("reserved_at < ?", cutoff_time).each do |appointment|
      appointment.update!(status: "expired")
    end
  end
end
