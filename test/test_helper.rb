ENV["RAILS_ENV"] = "test"

require 'simplecov' 
require "codeclimate-test-reporter"
SimpleCov.start 'rails'
CodeClimate::TestReporter.start


require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "database_cleaner"
require 'webmock/minitest'
# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Umment for awesome colorful output
# require "minitest/pride"

WebMock.disable_net_connect!(allow: [/codeclimate.com/])

module CreateOrderHelper
  def create_order
    some_time = Time.parse "10 AM"  ## gives time object in IST time zone
    Time.stub(:now, some_time) do
      order_obj = create :order
    end
  end
end
class ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include ActiveJob::TestHelper
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  include FactoryGirl::Syntax::Methods
  include ActiveJob::TestHelper
  fixtures :all
  DatabaseCleaner.strategy = :transaction

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end


