# frozen_string_literal: true

# Searchbox Elasticsearch configuration
if Rails.env.production?
  Elasticsearch::Model.client =
    Elasticsearch::Client.new(host: ENV["SEARCHBOX_URL"])
end
