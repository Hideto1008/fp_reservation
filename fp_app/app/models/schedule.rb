class Schedule < ApplicationRecord
  belongs_to :planner
  validates :planner_id, presence: true
  validate :check_started_at_future_or_present
  validate :check_schedule_within_working_hours

  def check_started_at_future_or_present
    if started_at < Time.now
      errors.add(:started_at, "can't be in the past")
    end
  end

  def check_schedule_within_working_hours
		check_not_sunday
  	check_valid_started_at_in_saturday
		check_valid_started_at_in_weekdays
	end		

	def check_not_sunday
		return unless started_at.sunday?
		if is_available
      errors.add(:started_at, "can't be on a Sunday")
		end
	end

	def check_valid_started_at_in_saturday
		return unless started_at.saturday?
		if is_available && started_at < started_at.change(hour: 11, min: 0)
			errors.add(:started_at, "can't be before 11:00 on Saturday")
		end
		if is_available && started_at >= started_at.change(hour: 15, min: 0)
			errors.add(:started_at, "can't be after 15:00 on Saturday")
		end
	end

	def check_valid_started_at_in_weekdays
		return if started_at.saturday? || started_at.sunday?
		if started_at < started_at.change(hour: 10, min: 0) && is_available
			errors.add(:started_at, "can't be before 10:00 on weekdays")
		end
		if started_at >= started_at.change(hour: 18, min: 0) && is_available
			errors.add(:started_at, "can't be after 18:00 on weekdays")
		end
	end
end
