source 'https://rubygems.org'
ruby '2.3.3'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'simple_form', '~> 3.2', '>= 3.2.1'
gem 'autoprefixer-rails', '~> 6.7', '>= 6.7.2'
gem 'rails', '~> 5.0.1'
gem 'toastr-rails'
gem 'haml-rails'
gem "nested_form"
gem 'kaminari'
gem 'breadcrumbs_on_rails'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
gem 'dotenv-rails'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'haml', '~> 4.0', '>= 4.0.7'
gem 'cancancan'
gem 'rmagick'
gem 'carrierwave', '~> 1.0'
gem 'sidekiq'
gem 'prawn'
gem 'prawn-table'
gem 'pdfkit'
gem 'wkhtmltopdf-heroku'
gem 'wkhtmltopdf-binary'
#DateTimePicker
gem 'momentjs-rails', '>= 2.9.0'
# gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
gem 'rollbar'
gem 'roo'
gem 'roo-xls'
gem 'carrierwave-aws'
# gem 'bootstrap-datepicker-rails', '1.4.0'

gem 'materialize-sass'
gem 'material_icons'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'minitest-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'webmock'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'bullet'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'devise'
gem 'devise-async', git: 'https://github.com/mhfs/devise-async.git', branch: 'devise-4.x'
gem 'faker'

group :test do 
  gem 'codeclimate-test-reporter', '< 1.0.0'
  gem 'simplecov', '>= 0.7.1'
  gem 'rails-controller-testing'
end

gem 'rails_12factor', group: :production
gem 'serviceworker-rails'
gem 'webpush'
