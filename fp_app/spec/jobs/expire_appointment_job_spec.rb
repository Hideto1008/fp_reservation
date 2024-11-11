require 'rails_helper'
require 'timecop'

RSpec.describe ExpireAppointmentJob, type: :job do
  let(:user) { create(:user) }
  let(:planner) { create(:planner) }
  let(:available_schedule) { create(:schedule, :reserved_schedule, planner: planner) }
  let(:future_appointment) { create(:appointment, user: user, planner: planner, schedule: available_schedule, reserved_at: available_schedule.started_at) }
  last_monday = Time.current.beginning_of_week - 7.days + 12.hours

  subject { ExpireAppointmentJob.perform_now }

  let!(:expired_appointment) do
    Timecop.travel(last_monday) do
      expired_schedule = create(:schedule, planner: planner, started_at: last_monday + 1.hour, is_available: true)
      create(:appointment, user: user, planner: planner, schedule: expired_schedule, reserved_at: expired_schedule.started_at, status: "reserved")
    end
  end

  let!(:done_appointment) do
    Timecop.travel(last_monday) do
      done_schedule = create(:schedule, planner: planner, started_at: last_monday + 2.hour, is_available: true)
      create(:appointment, user: user, planner: planner, schedule: done_schedule, reserved_at: done_schedule.started_at, status: "done")
    end
  end

  before do
    Timecop.freeze(Time.current)
  end

  after do
    Timecop.return
  end

  it "updates the status of expired appointments to 'expired'" do
    expect { subject }.to change { expired_appointment.reload.status }.from("reserved").to("expired")
    expect { subject }.not_to change { done_appointment.reload.status }
    expect { subject }.not_to change { future_appointment.reload.status }
  end
end
