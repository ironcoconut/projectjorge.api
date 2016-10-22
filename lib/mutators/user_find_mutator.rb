module Mutator
  class UserFind < Base

    attribute :id, String
    normalize :id

    attribute :handle, String
    normalize :handle

    attribute :email, String
    normalize :email, :with => :downcase

    attribute :phone, String
    normalize :phone, :with => :phone

    set_check_some('handle', 'email', 'phone', 'id')

  end
end
