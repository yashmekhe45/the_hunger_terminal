require_relative 'boot'

require 'rails/all'
require 'pdfkit'

require 'roo'

# xlsx = Roo::Spreadsheet.open('./new_prices.xlsx')
# xlsx = Roo::Excelx.new("./new_prices.xlsx")

# # Use the extension option if the extension is ambiguous.
# xlsx = Roo::Spreadsheet.open('./rails_temp_upload', extension: :xlsx)

# xlsx.info
# => Returns basic info about the spreadsheet file


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Railtie.load
include BreadcrumbsOnRails
module TheHungerTerminal
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
   
    config.active_record.time_zone_aware_types = [:datetime, :time]
    config.active_job.queue_adapter = :sidekiq
    config.time_zone = 'Kolkata'
    # config.active_record.default_timezone = :local
  end
end
