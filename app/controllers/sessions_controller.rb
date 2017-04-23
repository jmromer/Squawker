# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && valid_password?(user)
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = "Invalid email/password combination"
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  def trial
    params[:remember_me] = false
    user = User.find_by(username: "DIVYA")
    sign_in user
    redirect_back_or user
  end

  private

  def valid_password?(user)
    user.authenticate(params[:session][:password])
  end
end
