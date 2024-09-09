require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:planner) { create(:planner) } # Plannerのファクトリを使用して、関連するPlannerを作成

  describe 'validations' do
    it 'is valid with valid attributes' do
      schedule = build(:schedule, planner: planner)
      expect(schedule).to be_valid
    end

    it 'is invalid without a planner_id' do
      schedule = build(:schedule, planner: nil)
      expect(schedule).not_to be_valid
      expect(schedule.errors[:planner_id]).to include("can't be blank")
    end

    it 'is invalid with a started_at in the past' do
      schedule = build(:schedule, planner: planner, started_at: Time.now - 1.hour)
      schedule.check_started_at_future_or_present
      expect(schedule.errors[:started_at]).to include("can't be in the past")
    end

    it 'is invalid with a started_at on Sunday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-29 10:00:00"), is_available: true) # 2024年9月29日は日曜日
      schedule.check_schedule_within_working_hours
      expect(schedule.errors[:started_at]).to include("can't be on a Sunday")
    end

    it 'is invalid with a started_at before 11:00 on Saturday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-28 10:30:00"), is_available: true) # 2024年9月28日は土曜日
      schedule.check_schedule_within_working_hours
      expect(schedule.errors[:started_at]).to include("can't be before 11:00 on Saturday")
    end

    it 'is invalid with a started_at after 15:00 on Saturday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-28 15:30:00"), is_available: true) # 2024年9月28日は土曜日
      schedule.check_schedule_within_working_hours
      expect(schedule.errors[:started_at]).to include("can't be after 15:00 on Saturday")
    end

    it 'is invalid with a started_at before 10:00 on a weekday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-30 09:00:00"), is_available: true) # 2024年9月30日は月曜日
      schedule.check_schedule_within_working_hours
      expect(schedule.errors[:started_at]).to include("can't be before 10:00 on weekdays")
    end

    it 'is invalid with a started_at after 18:00 on a weekday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-30 18:30:00"), is_available: true) # 2024年8月1日は木曜日
      schedule.check_schedule_within_working_hours
      expect(schedule.errors[:started_at]).to include("can't be after 18:00 on weekdays")
    end

    it 'is valid with a started_at between 10:00 and 18:00 on a weekday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-30 12:00:00"), is_available: true) # 2024年8月1日は木曜日
      schedule.check_schedule_within_working_hours
      expect(schedule).to be_valid
    end

    it 'is valid with a started_at between 11:00 and 15:00 on Saturday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-28 12:00:00"), is_available: true) # 2024年9月28日は土曜日
      schedule.check_schedule_within_working_hours
      expect(schedule).to be_valid
    end
  end
end
