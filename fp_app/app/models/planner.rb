class Planner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :schedules, dependent: :destroy
  has_many :appointments, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
