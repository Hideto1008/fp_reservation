class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user
  before_action :find_user
  ITEMS_PER_PAGE = 7

  def show
    @appointments = @user.appointments.order(reserved_at: :desc).page(params[:page]).per(ITEMS_PER_PAGE)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Information updated successfully."
    else
      render :edit
    end
  end

  private

  def correct_user
    @user = User.find_by(id: params[:id])
    if @user.nil? || @user != current_user
      redirect_to root_path, alert: "You are not authorized to access this page"
    end
  end

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :icon_path)
  end
end
