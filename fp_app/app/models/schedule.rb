class Schedule < ApplicationRecord
    belongs_to :planner
    has_one :appointment
    validates :planner_id, presence: true
    validate :check_schedule
    validate :check_started_at

    def check_schedule
        if self.started_at < Time.now
            errors.add(:started_at, "can't be in the past")
        end
    end

    def check_started_at
        if self.started_at.sunday? && self.is_available
            errors.add(:started_at, "can't be on a Sunday")
        elsif self.started_at.saturday?
            errors.add(:started_at, "can't be before 11:00 on Saturday") if self.is_available && self.started_at < self.started_at.change(hour: 11, min: 0)
            errors.add(:started_at, "can't be after 15:00 on Saturday") if self.is_available && self.started_at >= self.started_at.change(hour: 15, min: 0)

        else
            errors.add(:started_at, "can't be before 10:00 on weekdays") if self.started_at < self.started_at.change(hour: 10, min: 0) && self.is_available
            errors.add(:started_at, "can't be after 18:00 on weekdays") if self.started_at >= self.started_at.change(hour: 18, min: 0) && self.is_available
        end
    end  
end
