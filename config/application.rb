# frozen_string_literal: true

require File.expand_path("../boot", __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Squawker
  class Application < Rails::Application
    WillPaginate.per_page = 10
    config.assets.precompile += %w[
      *.png
      *.jpg
      *.jpeg
      *.gif
      application.css
      application.js
    ]

    config.autoload_paths += Dir[Rails.root.join("app", "extensions", "*.rb")].each { |f| require f }
    config.autoload_paths += Dir[Rails.root.join("app", "services", "*.rb")].each { |f| require f }
  end
end
