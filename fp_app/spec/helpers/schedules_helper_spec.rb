require 'rails_helper'

RSpec.describe SchedulesHelper, type: :helper do
  let(:planner) { create(:planner) }
  let(:schedule_on_weekday) { create(:schedule, :reserved_schedule, planner: planner) }
  let(:schedule_on_weekday_unavailable) { create(:schedule, planner: planner) }
  let(:schedule_on_saturday) { create(:schedule, planner: planner, started_at: (Time.now.next_occurring(:saturday).beginning_of_day + 1.week) + 12.hours, is_available: true) }
  let(:schedule_on_saturday_blackout) { create(:schedule, planner: planner, started_at: (Time.now.next_occurring(:saturday).beginning_of_day) + 10.hours + 30.minutes, is_available: false) }
  let(:schedules) { [schedule_on_weekday, schedule_on_weekday_unavailable, schedule_on_saturday, schedule_on_saturday_blackout] }

  before do
    assign(:planner, planner)
  end

  describe '#times' do
    it 'returns the expected array of time slots' do
      expected_times = [
        "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30",
        "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30"
      ]
      expect(helper.times).to eq(expected_times)
    end
  end

  describe '#matching_schedule_or_blackout' do
    context 'when the day is a weekday' do
      it 'returns the correct availability link for available schedule' do
        weekday = schedule_on_weekday.started_at.to_date
        time = schedule_on_weekday.started_at.strftime("%H:%M")
        expect(helper.matching_schedule_or_blackout(weekday, time, schedules)).to include('◯')
      end

      it 'returns the correct availability link for unavailable schedule' do
        weekday = schedule_on_weekday_unavailable.started_at.to_date
        time = schedule_on_weekday_unavailable.started_at.strftime("%H:%M")
        expect(helper.matching_schedule_or_blackout(weekday, time, schedules)).to include('✖️')
      end
    end

    context 'when the day is Saturday' do
      it 'returns blackout for a time slot within blackout hours' do
        saturday = schedule_on_saturday_blackout.started_at.to_date
        time = schedule_on_saturday_blackout.started_at.strftime("%H:%M")
        expect(helper.matching_schedule_or_blackout(saturday, time, schedules)).to include('--')
      end

      it 'returns the correct availability link for an available time slot outside blackout hours' do
        saturday = schedule_on_saturday.started_at.to_date
        time = schedule_on_saturday.started_at.strftime("%H:%M")
        expect(helper.matching_schedule_or_blackout(saturday, time, schedules)).to include('◯')
      end
    end

    context 'when there is no matching schedule' do
      it 'returns a default link to create a new schedule' do
        random_day = Time.now.next_occurring(:monday).to_date
        time = '15:00'
        expect(helper.matching_schedule_or_blackout(random_day, time, schedules)).to include('--')
      end
    end
  end
end
