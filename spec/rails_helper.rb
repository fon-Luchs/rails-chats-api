ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/collection_matchers'
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.order = :random

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) { DatabaseRewinder.clean_all }

  config.after(:each) { DatabaseRewinder.clean }

  config.include Authorization
  config.include Permitter
  config.include Headers
  config.include FactoryBot::Syntax::Methods
end

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :rails
  end
end
