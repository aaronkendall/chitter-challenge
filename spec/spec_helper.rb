ENV['RACK_ENV'] = 'test'

require 'coveralls'
require 'simplecov'
require 'database_cleaner'
require 'capybara/rspec'
require_relative '../app/app'
require 'factory_girl'

Capybara.app = Chitter

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
Coveralls.wear!

RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods
    FactoryGirl.definition_file_paths = %w{./spec/factories}
    FactoryGirl.find_definitions

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
