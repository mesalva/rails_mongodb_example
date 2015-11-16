require 'rubygems'
require 'mongo'
#@settings = YAML.load(File.read(File.join(Rails.root, 'config/mongoid.yml')))[ENV['RAILS_ENV']||'development']
Mongoid.load!(File.join(Rails.root, 'config/mongoid.yml'))