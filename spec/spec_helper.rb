# spec/spec_helper.rb
require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'dm-rspec'
require "rack_session_access"
require "rack_session_access/capybara"
require 'capybara/poltergeist'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
  Capybara.app = Sinatra::Application
  Capybara.app.use RackSessionAccess::Middleware
  Capybara.javascript_driver = :poltergeist
end

# For RSpec 2.x and 3.x
RSpec.configure do |c|
  c.include RSpecMixin
  c.include Capybara::DSL
	c.include(DataMapper::Matchers)

	DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app_test.db")
  DataMapper.finalize
  User.auto_migrate!

end