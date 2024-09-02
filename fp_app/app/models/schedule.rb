class Schedule < ApplicationRecord
    belongs_to :planner
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
            errors.add(:started_at, "can't be before 11:00 on Saturday") if self.started_at < Time.parse("11:00:00") && self.is_available
            errors.add(:started_at, "can't be after 15:00 on Saturday") if self.started_at >= Time.parse("15:00:00") && self.is_available
        else
            errors.add(:started_at, "can't be before 10:00 on weekdays") if self.started_at < Time.parse("10:00:00") && self.is_available
            errors.add(:started_at, "can't be after 18:00 on weekdays") if self.started_at >= Time.parse("18:00:00") && self.is_available
        end
    end  
end
