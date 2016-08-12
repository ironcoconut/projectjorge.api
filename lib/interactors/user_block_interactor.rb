module Interactor
  class UserBlock < Base

    def validate
      v = Validator.new(body)
      v.coerce_string('handle', 'email', 'phone')
      v.some_present('handle', 'email', 'phone')
      @user_data = extract(v)
    end

    def user
      @user ||= UserModel.find_or_create_by(@user_data)
    end

    def relation
      @relation ||= UserGraph.create_relationship(current_user.id, user.id, :blocked).first
    end

    def authorize
      check_current_user
      check_errors(user)
      check_present(relation, "Unable to block user")
    end

    def main
    end

    def present
      set_response(:block, UserPresenter.new(user).block)
    end
  end
end
