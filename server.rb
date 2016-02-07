require 'sinatra'
require 'active_record'
require 'yaml'

ActiveRecord::Base.configurations = YAML::load_file(File.join(__dir__, 'config/database.yml'))
ActiveRecord::Base.establish_connection(:development)

class Donee < ActiveRecord::Base
end

class Volunteer < ActiveRecord::Base
end

class Charity < ActiveRecord::Base
end

class User < ActiveRecord::Base
end

get '/' do
  "go: #{Donee.all}"
end
