# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
# require 'devise'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Warden::Test::Helpers
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  config.include Rails.application.routes.url_helpers
  # config.include ActiveJob::TestHelper

  # ActiveJob::Base.queue_adapter = :test

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
