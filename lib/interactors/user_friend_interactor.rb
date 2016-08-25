module Interactor
  class UserFriend < Base

    def validate
      v = Validator::Base.new(body)
      v.coerce_string('handle', 'email', 'phone')
      v.some_present('handle', 'email', 'phone')
      @user_data = extract(v)
    end

    def user
      @user ||= Model::User.find_or_create_by(@user_data)
    end

    def relation
      @relation ||= Graph::User.create_relationship(current_user.id, user.id, :friended).first
    end

    def authorize
      check_current_user
      check_errors(user)
      check_present(relation, "Unable to create friendship")
    end

    def main
      MessagesService.friend(relation)
    end

    def present
      set_response(:friend, Presenter::User.new(user).friend)
    end
  end
end
