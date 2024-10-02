class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :planner
  belongs_to :schedule
  validates :user_id, presence: true
  validates :planner_id, presence: true
  validates :schedule_id, presence: true
  validate :check_reserved_at_is_future_or_present
  validate :check_appointment_availability

  private

  def check_reserved_at_is_future_or_present
    if reserved_at < Time.now && will_save_change_to_reserved_at?
        errors.add(:reserved_at, "can't be in the past")
    end
  end

  def check_appointment_availability
    return if schedule.nil?

    if schedule.booking_available?(planner_id, reserved_at)
      errors.add(:schedule_id, "is not available at the selected time")
    end
  end
end
