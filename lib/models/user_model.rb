module Model
  class User < ActiveRecord::Base
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
end
