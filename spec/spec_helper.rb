ENV['RACK_ENV'] = 'test'

require_relative '../cakes'
require 'database_cleaner'
require 'factory_girl'
require_relative './factories'
require 'json'
require 'rack/test'

def app
  Cakes.new
end

RSpec.configure do |c|
  c.include Rack::Test::Methods
  c.include FactoryGirl::Syntax::Methods

  c.before(:each) do
    DatabaseCleaner.start
  end

  c.after(:each) do
    DatabaseCleaner.clean
  end
end
