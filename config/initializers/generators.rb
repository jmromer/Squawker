Rails.application.config.generators do |g|
  g.orm :active_record
  g.test_framework :test_unit
  g.assets false
  g.helper false
  g.test_framework :rspec
  g.template_engine :haml
end
