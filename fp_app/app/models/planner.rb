class Planner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :schedules, dependent: :destroy
  has_many :appointments, dependent: :destroy

  scope :with_done_appointments, -> {
    left_joins(:appointments)
      .select("planners.*, SUM(CASE WHEN appointments.status = #{Appointment.statuses[:done]} THEN 1 ELSE 0 END) AS done_appointments_count")
      .group("planners.id")
      .order("done_appointments_count DESC, planners.id ASC")
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[appointments]
  end

  def done_appointments_count
    appointments.status_done.count
  end
end
