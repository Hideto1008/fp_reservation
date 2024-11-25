namespace :scheduler do
  desc "Expire appointments"
  task expire_appointments: :environment do
    ExpireAppointmentJob.perform_now
  end
end
