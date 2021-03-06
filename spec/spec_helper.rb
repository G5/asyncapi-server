ENV['RAILS_ENV'] ||= 'test'
SPEC_DIR = File.dirname(__FILE__)
DUMMY_DIR = File.join(SPEC_DIR, "dummy")

require File.join(DUMMY_DIR, "config", "environment")
require "rspec/rails"
require "rspec/its"
require "factory_girl_rails"
require "pry"
require "database_cleaner"
require "timecop"
require 'rspec-sidekiq'

Rails.backtrace_cleaner.remove_silencers!

# Load other files in spec directory

Dir[
  File.join(SPEC_DIR, "support", "*.rb"),
  File.join(SPEC_DIR, "fixtures", "*.rb"),
].each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before do |example|
    DatabaseCleaner.strategy = example.metadata[:cleaning_strategy] ||
      :transaction
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
