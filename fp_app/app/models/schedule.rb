class Schedule < ApplicationRecord
  belongs_to :planner
  has_one :appointment
  validates :planner_id, presence: true
  validate :check_started_at_future_or_present
  validate :check_schedule_within_working_hours
  WORKING_HOURS_SATURDAY = { start: 11, end: 15 }.freeze
  WORKING_HOURS_WEEKDAYS = { start: 10, end: 18 }.freeze

  def booking_available?(planner_id, started_at)
    schedule = Schedule.find_by(planner_id: planner_id, started_at: started_at)
    schedule.nil? || !schedule.is_available
  end

  private

  def check_started_at_future_or_present
    if started_at < Time.now && will_save_change_to_is_available?
      errors.add(:started_at, "Past records can't be updated")
    end
  end

  def check_schedule_within_working_hours
    check_not_closed_day
    check_valid_started_at_on_saturday
    check_valid_started_at_on_weekdays
  end

  def check_not_closed_day
    return unless started_at.sunday?

    if is_available
      errors.add(:started_at, "can't be on a closed day")
    end
  end

  def check_valid_started_at_on_saturday
    return unless started_at.saturday?
    if is_available && (started_at.hour < WORKING_HOURS_SATURDAY[:start] || started_at.hour >= WORKING_HOURS_SATURDAY[:end])
      errors.add(:started_at, "must be between #{WORKING_HOURS_SATURDAY[:start]}:00 and #{WORKING_HOURS_SATURDAY[:end]}:00 on Saturday")
    end
  end

  def check_valid_started_at_on_weekdays
    return if started_at.saturday? || started_at.sunday?
    if is_available && (started_at.hour < WORKING_HOURS_WEEKDAYS[:start] || started_at.hour >= WORKING_HOURS_WEEKDAYS[:end])
      errors.add(:started_at, "must be between #{WORKING_HOURS_WEEKDAYS[:start]}:00 and #{WORKING_HOURS_WEEKDAYS[:end]}:00 on weekdays")
    end
  end
end
