class Users::MypagesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def mypage
    @user = User.find(params[:id])
    @appointments = Appointment.where(user_id: @user.id)
  end

  def edit_user_info
    @user = User.find(params[:id])
  end

  def update_user_info
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_mypage_path(@user), notice: "Information updated successfully."
    else
      render :edit_user_info
    end
  end

  private

  def correct_user
    @user = User.find_by(id: params[:id])
    if @user.nil? || @user != current_user
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:name, :icon_path, :introduction)
  end
end
