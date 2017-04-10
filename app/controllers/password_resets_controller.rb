# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])

    user.try(:send_password_reset)

    message = "Password reset: Please check your email for further instructions."
    redirect_to root_url, notice: message
  end

  def edit
    @user = User.find_by!(password_reset_token: params[:id])
  end

  def update
    @user = User.find_by!(password_reset_token: params[:id])

    if @user.password_reset_at < 2.hours.ago
      redirect_to_set_new_password
    elsif @user.update_attributes(password_params)
      redirect_to_root
    else
      render :edit
    end
  end

  private

  def redirect_to_set_new_password
    flash[:error] = "Password reset has expired."
    redirect_to new_password_reset_path
  end

  def redirect_to_root
    flash[:success] = "Password has been reset."
    redirect_to root_url
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
