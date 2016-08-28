module Interactor
  class UserLogin < Base

    def main
      check_extraction do
      @user_data = extract(
        Mutator::UserLogin.new(body)
      )
      end

      check_errors(:user)

      set_response(:user, Presenter::User.new(user).user_token)
    end

    def user
      @user ||= Model::User.login(@user_data)
    end
  end
end
