# frozen_string_literal: true

namespace :elasticsearch do
  desc "Create elasticsearch indexes"
  task create_indexes: :environment do
    Squawk.__elasticsearch__.create_index!(force: true)
  end
end
