require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:user) { create(:user) }
  let(:planner) { create(:planner) }
  let(:schedule) { create(:schedule, planner: planner) }
  let(:reserved_schedule) { create(:schedule, :reserved_schedule, planner: planner) }
  let(:appointment) { create(:appointment, user: user, planner: planner, schedule: reserved_schedule, reserved_at: reserved_schedule.started_at, status: "reserved") }
  last_monday = Time.current.beginning_of_week - 7.days
  let(:past_appointment) do
    travel_to(last_monday) do
      past_schedule = create(:schedule, planner: planner, started_at: last_monday + 12.hours, is_available: true)
      create(:appointment, user: user, planner: planner, schedule: past_schedule, reserved_at: past_schedule.started_at, status: "reserved")
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      appointment = build(:appointment, user: user, schedule: reserved_schedule, planner: planner)
      expect(appointment).to be_valid
    end

    it 'is invalid without a user_id' do
      appointment = build(:appointment, user: nil, schedule: schedule, planner: planner)
      expect(appointment).not_to be_valid
      expect(appointment.errors[:user_id]).to include("can't be blank")
    end

    it 'is invalid without a schedule_id' do
      appointment = build(:appointment, user: user, schedule: nil, planner: planner)
      expect(appointment).not_to be_valid
      expect(appointment.errors[:schedule_id]).to include("is not available at the selected time")
    end

    it 'is invalid without a planner_id' do
      appointment = build(:appointment, user: user, schedule: schedule, planner: nil)
      expect(appointment).not_to be_valid
      expect(appointment.errors[:planner_id]).to include("can't be blank")
    end

    it 'is invalid with a reserved_at in the past' do
      appointment = build(:appointment, user: user, schedule: schedule, reserved_at: Time.now - 1.hour, status: 'done', planner: planner)
      appointment.update(status: 'reserved')
      expect(appointment.errors[:reserved_at]).to include("can't be in the past")
    end

    it 'is invalid when the planner is not available' do
      appointment = build(:appointment, user: user, schedule: schedule, planner: planner)
      schedule.update(is_available: false)
      expect(appointment.errors[:schedule_id]).to include("is not available at the selected time")
    end

    it "can not cancel past appointment" do
      past_appointment.status = "canceled"
      expect(past_appointment).not_to be_valid
    end

    it "can not update the status to 'done' when the appointment is in the future" do
      appointment.status = "done"
      expect(appointment).not_to be_valid
    end
  end
end
