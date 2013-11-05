class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    user.send_password_reset if user
    redirect_to root_url, notice: "Password reset: Please check your email for further instructions."
  end

  def edit
    @user = User.find_by!(password_reset_token: params[:id])
  end

  def update
    @user = User.find_by!(password_reset_token: params[:id])

    if @user.password_reset_at < 2.hours.ago
      flash[:error] = "Password reset has expired."
      redirect_to new_password_reset_path
    elsif @user.update_attributes(password_params)
      flash[:success] = "Password has been reset."
      redirect_to root_url
    else
      render :edit
    end
  end

  private
    def password_params
      params.require(:user)
            .permit(:password, :password_confirmation)
    end

end
