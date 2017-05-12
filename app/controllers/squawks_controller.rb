# frozen_string_literal: true

class SquawksController < ApplicationController
  before_action :signed_in_user, only: %i[create destroy]
  layout false

  def create
    squawk = current_user.squawks.build(squawk_params)

    if squawk.save
      render template: "activity_feed/index",
             locals: { squawks: [squawk] },
             status: :ok
    else
      render text: squawk.errors.full_messages.first,
             status: :unprocessable_entity
    end
  end

  def destroy
    squawk = current_user.squawks.find(params[:id])

    if squawk.destroy
      head 200
    else
      head :unprocessable_entity
    end
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
