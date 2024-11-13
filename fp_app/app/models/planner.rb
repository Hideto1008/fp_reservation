class Planner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :schedules, dependent: :destroy
  has_many :appointments, dependent: :destroy

  scope :with_done_appointments, -> {
    joins(:appointments)
      .where(appointments: { status: "done" })
      .group("planners.id")
      .order("COUNT(appointments.id) DESC")
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def count_done_appointment
    appointments.where(status: "done").count
  end
end
