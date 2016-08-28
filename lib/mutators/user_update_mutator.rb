module Mutator
  class UserUpdate < Base

    attribute :handle, String
    normalize :handle

    attribute :email, String
    normalize :email

    # TODO: add password confimation field? or remove password completely for email based login?
    attribute :password, String
    normalize :password

    attribute :phone, String
    normalize :phone, :with => :phone

    attribute :avatar, String
    normalize :avatar

    attribute :contact_frequency, String
    normalize :contact_frequency

    attribute :prefer_email, Boolean
    normalize :prefer_email, :with => :boolean

    attribute :prefer_phone, Boolean
    normalize :prefer_phone, :with => :boolean

    set_check_some('handle', 'email', 'password', 'phone', 'avatar', 'prefer_email', 'prefer_phone', 'contact_frequency')

  end
end
