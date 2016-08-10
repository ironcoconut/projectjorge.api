require 'active_record'
require 'yaml'
require 'bcrypt'

ActiveRecord::Base.configurations = YAML::load_file(File.join(__dir__, '../../config/database.yml'))
ActiveRecord::Base.establish_connection((ENV['RACK_ENV'] ||:development).to_sym)
ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV['RACK_ENV'] == :development

class UserModel < ActiveRecord::Base
  self.table_name = "users"
  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end
  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
  def self.login(opts)
    password = opts.delete('password')
    user = self.where(opts).first
    return nil if user.nil?
    if (user.password == password)
      return user
    else
      return nil
    end
  end
end

class UserRelationModel < ActiveRecord::Base
  self.table_name = "user_relations"

  def self.related(*a)
    return true
  end
end

class UserEventTemplateModel < ActiveRecord::Base
  self.table_name = "user_event_templates"
end

class EventTemplateModel < ActiveRecord::Base
  self.table_name = "event_templates"
end

class EventModel < ActiveRecord::Base
  self.table_name = "events"
end

class UserEventModel < ActiveRecord::Base
  self.table_name = "user_events"
end
