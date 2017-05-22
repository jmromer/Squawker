# frozen_string_literal: true

class RecommendationsController < ApplicationController
  layout false

  def index
    squawk_ids = Warbler.recommendations(squawk_params)
    squawks = Squawk.where(id: squawk_ids)
    render "activity_feed/index", locals: { squawks: squawks }
  rescue ActionController::ParameterMissing
    head :unprocessable_entity
  end

  private

  def squawk_params
    params.require(:squawk_id)
  end
end
