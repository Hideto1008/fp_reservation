class Planner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :schedules, dependent: :destroy
  has_many :appointments, dependent: :destroy
  DONE = 2

  scope :with_done_appointments, -> {
    left_joins(:appointments)
      .select("planners.*, SUM(CASE WHEN appointments.status = #{DONE} THEN 1 ELSE 0 END) AS done_appointments_count")
      .group("planners.id")
      .order("done_appointments_count DESC, planners.id ASC")
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def count_done_appointment
    appointments.where(status: "done").count
  end
end
