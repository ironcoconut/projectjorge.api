module Interactor
  class UserLogin < Base

    def validate
      v = Validator.new(body)
      v.coerce_string('handle', 'email', 'phone', 'password') 
      v.all_present('password')
      v.some_present('handle', 'email', 'phone')
      @user_data = extract(v)
    end

    def user
      @user ||= UserModel.login(@user_data)
    end

    def authorize
      check_errors(user)
    end

    def main
    end

    def present
      set_response(:user, UserPresenter.new(user).user_token)
    end
  end
end
