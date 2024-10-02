require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:user) { create(:user) } # Userのファクトリを使用して、関連するUserを作成
  let(:planner) { create(:planner) } # Plannerのファクトリを使用して、関連するPlannerを作成
  let(:schedule) { create(:schedule, planner: planner) } # Scheduleのファクトリを使用して、関連するScheduleを作成
  let(:reserved_schedule) { create(:schedule, :reserved_schedule, planner: planner) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      appointment = build(:appointment, user: user, schedule: reserved_schedule, planner: planner)
      expect(appointment).to be_valid
    end

    # user_idがない場合無効であること
    it 'is invalid without a user_id' do
      appointment = build(:appointment, user: nil, schedule: schedule, planner: planner)
      expect(appointment).not_to be_valid
      expect(appointment.errors[:user_id]).to include("can't be blank")
    end

    # schedule_idがない場合無効であること
    it 'is invalid without a schedule_id' do
      appointment = build(:appointment, user: user, schedule: nil, planner: planner)
      expect(appointment).not_to be_valid
      expect(appointment.errors[:schedule_id]).to include("can't be blank")
    end

    # planner_idがない場合無効であること
    it 'is invalid without a planner_id' do
      appointment = build(:appointment, user: user, schedule: schedule, planner: nil)
      expect(appointment).not_to be_valid
      expect(appointment.errors[:planner_id]).to include("can't be blank")
    end

    # reserved_atが過去で、statusが"reserved"である場合無効であること
    it 'is invalid with a reserved_at in the past' do
      appointment = build(:appointment, user: user, schedule: schedule, reserved_at: Time.now - 1.hour, status: 'done', planner: planner)
      appointment.update(status: 'reserved')
      expect(appointment.errors[:reserved_at]).to include("can't be in the past")
    end

    # plannerが利用可能でない場合無効であること
    it 'is invalid when the planner is not available' do
      appointment = build(:appointment, user: user, schedule: schedule, planner: planner)
      schedule.update(is_available: false)
      expect(appointment.errors[:schedule_id]).to include("is not available at the selected time")
    end
  end
end
