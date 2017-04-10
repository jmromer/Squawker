# frozen_string_literal: true

class SquawksController < ApplicationController
  before_action :signed_in_user, only: %i[create destroy]

  def create
    @squawk = current_user.squawks.build(squawk_params)

    if @squawk.save
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    @squawk = correct_user

    @squawk.destroy

    redirect_to session[:return_to]
  end

  private

  def squawk_params
    params.require(:squawk).permit(:content)
  end

  def correct_user
    current_user.squawks.find(params[:id])
  rescue
    redirect_to root_url
  end
end
