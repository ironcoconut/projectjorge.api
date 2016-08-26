### REQUIRE OUR GEMS

require 'yaml'
require 'neo4j-core'
require 'active_record'
require 'bcrypt'
require 'sinatra/base'
require 'sinatra/json'
require "sinatra/namespace"
require "sinatra/cookies"
require "rack/contrib"
require "json"
require 'jwt'
require 'normalizr'
require 'virtus'


### NEO4J

# might cause a circular dependency if `lib/graph/base` cannot be loaded before this file
Graph::Base.config = PJConfig.graph
Graph::Base.establish_connection(ENV['RACK_ENV'] || 'development')


### ACTIVE RECORD

ActiveRecord::Base.configurations = PJConfig.db
ActiveRecord::Base.establish_connection((ENV['RACK_ENV'] ||:development).to_sym)
ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV['RACK_ENV'] == :development


### NORMALIZR

Normalizr.configure do
    default :strip, :blank
end
