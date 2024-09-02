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
      schedule.check_schedule
      expect(schedule.errors[:started_at]).to include("can't be in the past")
    end

    it 'is invalid with a started_at on Sunday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-08-04 10:00:00"), is_available: true) # 2024年8月4日は日曜日
      schedule.check_started_at
      expect(schedule.errors[:started_at]).to include("can't be on a Sunday")
    end

    it 'is invalid with a started_at before 11:00 on Saturday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-08-03 10:30:00"), is_available: true) # 2024年8月3日は土曜日
      schedule.check_started_at
      expect(schedule.errors[:started_at]).to include("can't be before 11:00 on Saturday")
    end

    it 'is invalid with a started_at after 15:00 on Saturday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-08-03 15:30:00"), is_available: true) # 2024年8月3日は土曜日
      schedule.check_started_at
      expect(schedule.errors[:started_at]).to include("can't be after 15:00 on Saturday")
    end

    it 'is invalid with a started_at before 10:00 on a weekday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-08-01 09:00:00"), is_available: true) # 2024年8月1日は木曜日
      schedule.check_started_at
      expect(schedule.errors[:started_at]).to include("can't be before 10:00 on weekdays")
    end

    it 'is invalid with a started_at after 18:00 on a weekday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-08-01 18:30:00"), is_available: true) # 2024年8月1日は木曜日
      schedule.check_started_at
      expect(schedule.errors[:started_at]).to include("can't be after 18:00 on weekdays")
    end
  end
end
