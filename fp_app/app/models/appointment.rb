class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :planner
  belongs_to :schedule
  validates :user_id, presence: true
  validates :planner_id, presence: true
  validates :schedule_id, presence: true


  def check_schedule
    if self.reserved_at < Time.now && self.status == "reserved"
        errors.add(:reserved_at, "can't be in the past")
    end
  end

  def check_planner_status
    self.schedule.started_at = self.reserved_at
    if self.schedule.started_at && self.schedule.is_available == false
      errors.add(:planner_id, "is not available")
    end
  end
end
