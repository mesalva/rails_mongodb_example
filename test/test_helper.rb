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
		insert_one(document, options)
	end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #fixtures :all
  setup do
  	  db_config = YAML.load_file("#{Rails.root}/config/database.mongo.yml")[Rails.env]
  	  db = Mongo::Client.new([ "#{db_config[:host]||'localhost'}:#{db_config[:port]||27017}" ],
  	  	 :database => db_config[:database]||"test")

	  #p "data: #{DB[:users].find.to_a.size}"
	  db[:users].drop
	  db[:posts].drop
	  db[:user_rankings].drop

	  fixture_some_data = Mongo::Fixture.new :ranking, db

  end
  

end
