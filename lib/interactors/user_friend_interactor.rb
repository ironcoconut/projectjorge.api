module Interactor
  class UserFriend < Base

    def main
      check_extraction do
        @user_data = extract(
          Mutator::UserFind.new(body)
        )
      end

      check_current_user
      check_errors(:user)
      check_present(:relation)

      MessagesService.friend(relation)

      set_response(:friend, Presenter::User.new(user).friend)
    end

    private

    def user
      @user ||= Model::User.find_or_create_by(@user_data)
    end

    def relation
      @relation ||= Graph::User.create_relationship(current_user.id, user.id, :friended).first
    end
  end
end
