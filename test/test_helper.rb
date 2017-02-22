ENV["RAILS_ENV"] = "test"
# require 'simplecov' 
# require "codeclimate-test-reporter"
# SimpleCov.start 
# CodeClimate::TestReporter.start

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"


# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Umment for awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  include FactoryGirl::Syntax::Methods
  fixtures :all
  # Add more helper methods to be used by all tests here...
end
