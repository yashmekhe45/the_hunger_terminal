ENV["RAILS_ENV"] = "test"

require 'simplecov'
require "codeclimate-test-reporter"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

SimpleCov.start
CodeClimate::TestReporter.start
# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  include FactoryGirl::Syntax::Methods
  fixtures :all
  # Add more helper methods to be used by all tests here...
end
