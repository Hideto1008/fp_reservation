set :environment, 'deployment'

every 10.minutes do
  runner "ExpireAppointmentJob"
end
