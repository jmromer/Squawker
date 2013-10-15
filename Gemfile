source 'https://rubygems.org'
ruby '2.0.0'
#ruby-gemset=railstutorial_rails_4_0

gem 'rails', '4.0.0'
gem 'pg', '0.15.1'
gem 'bootstrap-sass', '2.3.2.0'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'

gem 'sass-rails', '4.0.0'     # Use SCSS for stylesheets
gem 'uglifier', '2.1.1'       # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '4.0.0'   # Use CoffeeScript for .js.coffee assets and views
gem 'jquery-rails', '3.0.4'   # Use jquery as the JavaScript library
gem 'turbolinks', '1.1.1'     # Makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'jbuilder', '1.0.2'       # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

group :development, :test do
  gem 'pry-rails'             # use pry for rails console
  gem 'annotate'              # annotate models

  gem 'better_errors'         # better errors, duh
  gem 'binding_of_caller'     # REPL in better errors
  gem 'debugger'              # for debugging

  gem 'rspec-rails', '2.13.1' # rspec as alternative TDD language
  gem 'guard-rspec', '2.5.0'  # guard to automate rspec
  gem 'spork-rails', '4.0.0'  # spork and dependcies to speed up guard
  gem 'guard-spork', '1.5.0'  # use `spork --bootstrap` to bootstrap spork configuration
  gem 'childprocess', '0.3.6'

  gem 'autotest'
  gem 'autotest-rails'        # for automated testing with growl
  gem 'autotest-growl'
  gem 'autotest-fsevent'

  gem 'meta_request'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'  # Capybara dependency
  gem 'capybara', '2.1.0'             # Simulates user interaction with application
  gem 'factory_girl_rails', '4.2.1'   # Creates users
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end

# gem 'therubyracer', platforms: :ruby  # See http://j.mp/163fN1X for more supported runtimes
# gem 'bcrypt-ruby', '~> 3.0.0'         # Use ActiveModel has_secure_password
# gem 'unicorn'                         # Use unicorn as the app server
# gem 'capistrano', group: :development # Use Capistrano for deployment
