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
  end

  describe 'custom validation methods' do
    it 'is invalid with a started_at in the past and is_available has changed' do
      schedule = build(:schedule, planner: planner, started_at: Time.now - 1.hour, is_available: false)
      # is_availableを更新
      schedule.is_available = true
      expect(schedule).not_to be_valid
      expect(schedule.errors[:started_at]).to include("Past records can't be updated")
    end

    it 'is valid with a started_at in the past and is_available has not changed' do
      schedule = build(:schedule, planner: planner, started_at: Time.now - 1.hour, is_available: false)
      expect(schedule).to be_valid
    end

    it 'is invalid with a started_at on Sunday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-29 10:00:00"), is_available: true) # 2024年9月29日は日曜日
      expect(schedule).not_to be_valid
      expect(schedule.errors[:started_at]).to include("can't be on a closed day")
    end

    it 'is invalid with a started_at before 11:00 on Saturday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-28 10:30:00"), is_available: true) # 2024年9月28日は土曜日
      expect(schedule).not_to be_valid
      expect(schedule.errors[:started_at]).to include("must be between 11:00 and 15:00 on Saturday")
    end

    it 'is invalid with a started_at after 15:00 on Saturday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-28 15:30:00"), is_available: true) # 2024年9月28日は土曜日
      expect(schedule).not_to be_valid
      expect(schedule.errors[:started_at]).to include("must be between 11:00 and 15:00 on Saturday")
    end

    it 'is invalid with a started_at before 10:00 on a weekday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-30 09:00:00"), is_available: true) # 2024年9月30日は月曜日
      expect(schedule).not_to be_valid
      expect(schedule.errors[:started_at]).to include("must be between 10:00 and 18:00 on weekdays")
    end

    it 'is invalid with a started_at after 18:00 on a weekday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-30 18:30:00"), is_available: true) # 2024年8月1日は木曜日
      expect(schedule).not_to be_valid
      expect(schedule.errors[:started_at]).to include("must be between 10:00 and 18:00 on weekdays")
    end

    it 'is valid with a started_at between 10:00 and 18:00 on a weekday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-30 12:00:00"), is_available: true) # 2024年8月1日は木曜日
      expect(schedule).to be_valid
    end

    it 'is valid with a started_at between 11:00 and 15:00 on Saturday' do
      schedule = build(:schedule, planner: planner, started_at: Time.parse("2024-09-28 12:00:00"), is_available: true) # 2024年9月28日は土曜日
      expect(schedule).to be_valid
    end
  end
end
