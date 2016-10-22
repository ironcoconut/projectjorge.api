module Mutator
  class UserLogin < Base

    EmailRegex = /^.+@.+\..+$/
    PhoneRegex = /^\d+$/

    attribute :password, String
    normalize :password

    attribute :identifier, String
    normalize :identifier

    set_check_all('password', 'identifier')

    def attributes
      data = { password: password }

      case identifier
      when EmailRegex
        data[:email] = identifier
      when PhoneRegex
        data[:phone] = identifier
      else
        data[:handle] = identifier
      end

      return data
    end
  end
end
