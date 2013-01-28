ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'debugger'
require 'database_cleaner'

require_relative '../issue_tracker'

DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  before :each do
    DatabaseCleaner.clean
  end
end
