require 'rubygems'
require 'mongo'
p "\n\n\n\n\n environment here: #{Rails.env}"
#@settings = YAML.load(File.read(File.join(Rails.root, 'config/mongoid.yml')))[ENV['RAILS_ENV']||'development']
Mongoid.load!(File.join(Rails.root, 'config/mongoid.yml'))