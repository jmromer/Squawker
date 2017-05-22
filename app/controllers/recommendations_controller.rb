# frozen_string_literal: true

class RecommendationsController < ApplicationController
  layout false
  BASE_URL = "http://localhost:5000"

  def index
    squawk_id = params.require(:squawk_id)
    resp = HTTParty.get("#{BASE_URL}/recommendation?squawk_id=#{squawk_id}")
    json = JSON.parse(resp.body, symbolize_names: true)
    squawks = Squawk.where(id: json[:squawk_ids])
    render "activity_feed/index", locals: { squawks: squawks }
  rescue ActionController::ParameterMissing
    head :unprocessable_entity
  end
end
