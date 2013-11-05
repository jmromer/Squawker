class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    user.send_password_reset if user
    redirect_to root_url, notice: "Password reset: Please check your email for further instructions."
  end
end
