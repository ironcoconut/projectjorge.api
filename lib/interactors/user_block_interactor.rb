module Interactor
  class UserBlock < Base

    def main
      check_extraction do
        @user_data = extract(
          Mutator::UserFind.new(body)
        )
      end

      check_current_user
      check_errors(:user)
      check_present(:relation)

      set_response(:block, Presenter::User.new(user).block)
    end

    def user
      @user ||= Model::User.find_or_create_by(@user_data)
    end

    def relation
      @relation ||= Graph::User.create_relationship(current_user.id, user.id, :blocked).first
    end
  end
end
