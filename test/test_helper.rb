ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mongo'
require 'mongo-fixture'

class Mongo::Collection
	def count
		find.to_a.size
	end

	def insert(document, options={})
		insert_one(document, options={})
	end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #fixtures :all
  DB = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')

  #p "data: #{DB[:users].find.to_a.size}"
  DB[:users].drop
  DB[:posts].drop

  fixture_some_data = Mongo::Fixture.new :users, DB

end
