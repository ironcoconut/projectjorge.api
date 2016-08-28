module Interactor
  class UserRegistration < Base

    def main
      check_extraction do
        @user_data = extract(
          Mutator::UserRegistration.new(body)
        )
      end

      check_errors(:user)

      MessagesService.register(user)

      set_response(:user, Presenter::User.new(user).user_token)
    end

    private

    def user
      @user ||= Model::User.create(@user_data)
    end
  end
end
