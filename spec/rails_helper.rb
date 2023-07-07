
require 'spec_helper'
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.javascript_driver = :selenium_chrome

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  
  config.use_transactional_fixtures = true

  
  config.infer_spec_type_from_file_location!

 
  config.filter_rails_from_backtrace!
 
  config.include FactoryBot::Syntax::Methods
end
