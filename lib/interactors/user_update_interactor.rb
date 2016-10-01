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

      set_response(:user, Presenter::User.new(user_model).user)
    end

    private

    def update_user
      user_model.update(@user_data)
      user_model
    end

    def user_model
      current_user.model
    end
  end
end
