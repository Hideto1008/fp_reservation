class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :appointments, dependent: :destroy
  before_validation :set_default_icon_path, on: [:create, :update]

  def set_default_icon_path
    self.icon_path = ActionController::Base.helpers.asset_path("user_default_icon.png") if self.icon_path.blank?
  end
end
