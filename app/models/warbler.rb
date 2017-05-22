# frozen_string_literal: true

class Warbler
  include HTTParty
  base_uri ENV.fetch("WARBLER_URL", "http://localhost:5000")

  class << self
    def recommendations(squawk_id)
      resp = get("/recommendation?squawk_id=#{squawk_id}")
      json = JSON.parse(resp.body, symbolize_names: true)
      json.fetch(:squawk_ids)
    end
  end
end
