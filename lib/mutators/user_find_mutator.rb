module Mutator
  class UserFind < Base

    attribute :user_id, String
    normalize :user_id

    attribute :handle, String
    normalize :handle

    attribute :email, String
    normalize :email

    attribute :phone, String
    normalize :phone, :with => :phone

    set_check_some('handle', 'email', 'phone', 'user_id')

  end
end
