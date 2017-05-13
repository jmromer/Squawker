# frozen_string_literal: true

class FlagsController < ApplicationController
  before_action :signed_in_user

  def create
    flag = current_user.flags.build(squawk_id: params[:squawk_id])

    respond_to do |format|
      format.html { head :not_found }
      format.js do
        if flag.save
          head :ok
        else
          render json: { errors: flag.errors.full_messages },
                 status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    flag = current_user.flags.find_by(squawk_id: params[:squawk_id])

    respond_to do |format|
      format.html { head :not_found }
      format.js do
        if flag.try(:destroy)
          head :ok
        else
          head :not_found
        end
      end
    end
  end
end
