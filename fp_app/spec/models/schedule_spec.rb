require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:planner) { create(:planner) }
  let(:schedule) { create(:schedule, planner: planner) }
  let(:reserved_schedule) { create(:schedule, :reserved_schedule, planner: planner) }

  # テストで使用する日付と時間の変数
  let(:past_time) { Time.now - 1.hour }
  let(:weekday_before_10) { (Time.now.beginning_of_week + 1.week) + 9.hours }     # 来週平日の09:00
  let(:weekday_between) { (Time.now.beginning_of_week + 1.week) + 12.hours }      # 来週平日の12:00
  let(:weekday_after_18) { (Time.now.beginning_of_week + 1.week) + 18.hours + 30.minutes }  # 来週平日の18:30
  let(:saturday_before_11) { (Time.now.next_occurring(:saturday).beginning_of_day + 1.week) + 10.hours + 30.minutes }  # 来週土曜日の10:30
  let(:saturday_between) { (Time.now.next_occurring(:saturday).beginning_of_day + 1.week) + 12.hours }      # 来週土曜日の12:00
  let(:saturday_after_15) { (Time.now.next_occurring(:saturday).beginning_of_day + 1.week) + 15.hours + 30.minutes }  # 来週土曜日の15:30
  let(:sunday) { (Time.now.next_occurring(:sunday) + 1.week).beginning_of_day + 10.hours }  # 来週日曜日の10:00

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
      schedule = build(:schedule, planner: planner, started_at: past_time, is_available: false)
      schedule.is_available = true
      expect(schedule).not_to be_valid
      expect(schedule.errors[:started_at]).to include("Past records can't be updated")
    end

    it 'is valid with a started_at in the past and is_available has not changed' do
      schedule = build(:schedule, planner: planner, started_at: past_time, is_available: false)
      expect(schedule).to be_valid
    end

    it 'is invalid with a started_at on Sunday' do
      schedule = build(:schedule, planner: planner, started_at: sunday, is_available: true)
      expect(schedule).not_to be_valid
      expect(schedule.errors[:started_at]).to include("can't be on a closed day")
    end

    it 'is invalid with a started_at before 11:00 on Saturday' do
      schedule = build(:schedule, planner: planner, started_at: saturday_before_11, is_available: true)
      expect(schedule).not_to be_valid
      expect(schedule.errors[:started_at]).to include("must be between 11:00 and 15:00 on Saturday")
    end

    it 'is invalid with a started_at after 15:00 on Saturday' do
      schedule = build(:schedule, planner: planner, started_at: saturday_after_15, is_available: true)
      expect(schedule).not_to be_valid
      expect(schedule.errors[:started_at]).to include("must be between 11:00 and 15:00 on Saturday")
    end

    it 'is invalid with a started_at before 10:00 on a weekday' do
      schedule = build(:schedule, planner: planner, started_at: weekday_before_10, is_available: true)
      expect(schedule).not_to be_valid
      expect(schedule.errors[:started_at]).to include("must be between 10:00 and 18:00 on weekdays")
    end

    it 'is invalid with a started_at after 18:00 on a weekday' do
      schedule = build(:schedule, planner: planner, started_at: weekday_after_18, is_available: true)
      expect(schedule).not_to be_valid
      expect(schedule.errors[:started_at]).to include("must be between 10:00 and 18:00 on weekdays")
    end

    it 'is valid with a started_at between 10:00 and 18:00 on a weekday' do
      schedule = build(:schedule, planner: planner, started_at: weekday_between, is_available: true)
      expect(schedule).to be_valid
    end

    it 'is valid with a started_at between 11:00 and 15:00 on Saturday' do
      schedule = build(:schedule, planner: planner, started_at: saturday_between, is_available: true)
      expect(schedule).to be_valid
    end
  end

  describe 'booking_available?' do
    it 'returns false if the schedule exists and is available' do
      schedule = create(:schedule, :reserved_schedule, planner: planner)
      result = schedule.booking_available?(planner.id, schedule.started_at)
      expect(result).to be false
    end

    it 'returns true if no schedule exists at the given time' do
      schedule = Schedule.new
      result = schedule.booking_available?(planner.id, weekday_between)
      expect(result).to be true
    end

    it 'returns true if the schedule exists but is unavailable' do
      create(:schedule, planner: planner, started_at: weekday_between, is_available: false)
      schedule = Schedule.new
      result = schedule.booking_available?(planner.id, weekday_between)
      expect(result).to be true
    end
  end
end
