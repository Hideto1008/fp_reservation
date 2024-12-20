class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :planner
  belongs_to :schedule
  validates :user_id, presence: true
  validates :planner_id, presence: true
  validates :schedule, presence: true
  validate :check_reserved_at_is_future_or_present
  validate :check_appointment_availability, on: :create
  validate :check_duplicate_appointment, on: :create
  validate :check_past_appintment_when_canceled, on: :update
  validate :chaeck_future_appointment_when_done, on: :update

  enum status: { reserved: 0, canceled: 1, done: 2, expired: 3 }, _prefix: true

  private

  def check_reserved_at_is_future_or_present
    if reserved_at < Time.current && new_record?
      errors.add(:reserved_at, "can't be in the past")
    end
  end

  def check_appointment_availability
    schedule = Schedule.find_by(planner_id: planner_id, started_at: reserved_at)
    if schedule.nil? || !schedule.is_available
      errors.add(:schedule_id, "is not available at the selected time")
    end
  end

  def check_duplicate_appointment
    if Appointment.exists?(user_id: user_id, reserved_at: reserved_at, status: "reserved") || Appointment.exists?(planner_id: planner_id, reserved_at: reserved_at, status: "reserved")
      errors.add(:base, "Already booked for the same date and time")
    end
  end

  def check_past_appintment_when_canceled
    if status_canceled? && reserved_at < Time.current && will_save_change_to_status?
      errors.add(:base, "Unable to cancel past appointment")
    end
  end

  def chaeck_future_appointment_when_done
    if status_done? && reserved_at > Time.current && will_save_change_to_status?
      errors.add(:base, "Unable to mark future appointment as done")
    end
  end
end
