class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :planner
  belongs_to :schedule
  validates :user_id, presence: true
  validates :planner_id, presence: true
  validates :schedule_id, presence: true
  validate :check_schedule
  validate :check_planner_status

  private

  def check_schedule
    if reserved_at < Time.now && will_save_change_to_reserved_at?
        errors.add(:reserved_at, "can't be in the past")
    end
  end

  def check_planner_status
    schedule = Schedule.find_by(planner_id: planner_id, started_at: reserved_at)
    if schedule.nil? || !schedule.is_available
      errors.add(:planner_id, "is not available at the selected time")
    end
  end
end
