require './lib/index.rb'

if ENV['RACK_ENV'] != :production
  require 'pry'
end

map("/api") { run PJApi }
