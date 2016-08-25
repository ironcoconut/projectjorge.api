module Interactor
  class UserRegistration < Base

    def validate
      v = Validator::Base.new(body)
      v.coerce_string('handle', 'email', 'password', 'phone', 'avatar', 'contact_frequency')
      v.coerce_bool('prefer_email', 'prefer_phone')
      v.some_present('handle', 'email', 'phone')
      v.all_present('password')
      @user_data = extract(v)
    end

    def user
      @user ||= Model::User.create(@user_data)
    end

    def authorize
      check_errors(user)
    end

    def main
      MessagesService.register(user)
    end

    def present
      set_response(:user, Presenter::User.new(user).user_token)
    end
  end
end
