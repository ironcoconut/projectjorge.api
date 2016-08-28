module Interactor
  class UserUpdate < Base

    def main
      check_extraction do
        @user_data = extract(
          Mutator::UserUpdate.new(body)
        )
      end

      check_current_user
      check_errors(:update_user)

      set_response(:user, Presenter::User.new(current_user).user)
    end

    private

    def update_user
      current_user.update(@user_data)
      current_user
    end
  end
end
