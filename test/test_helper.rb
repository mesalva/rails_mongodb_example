ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mongo'
require 'mongo-fixture'

#Workaround for mongo-fixture framework
class Mongo::Collection
	def count
		find.to_a.size
	end

	def insert(document, options={})
		insert_one(document, options)
	end
end

class ActiveSupport::TestCase

  setup do
  	  #Load database config
  	  db_config = YAML.load_file("#{Rails.root}/config/database.mongo.yml")[Rails.env]

  	  #Create mongo client for mongo fixtures
  	  connection = Mongo::Client.new([ "#{db_config[:host]||'localhost'}:#{db_config[:port]||27017}" ],
  	  	 :database => db_config[:database]||"test")

  	  connection.database.collections.each do |collection|
  	  	collection.drop
  	  end
	  # Load the fixtures to test database
	  fixture_some_data = Mongo::Fixture.new :ranking, connection

  end
  

end
