module Mutator
  class UserLogin < Base

    attribute :password, String
    normalize :password

    attribute :handle, String
    normalize :handle

    attribute :email, String
    normalize :email

    attribute :phone, String
    normalize :phone, :with => :phone

    set_check_some('handle', 'email', 'phone')
    set_check_all('password')

  end
end
