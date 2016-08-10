module Interactor
  class UserFind < Base

    def validate
      v = Validator.new(body)
      v.coerce_string('handle')
      @user_data = extract(v)
    end

    def user
      @user ||= UserModel.where(@user_data).first || current_user
    end

    def relation
      @relation ||= UserRelationModel.related(current_user, user)
    end

    def authorize
      check_current_user
      check_errors(user, 'Unable to find user')
      check_true(relation, 'Unable to find user')
    end

    def main
    end

    def present
      set_response(:user, UserPresenter.new(user).user_token)
    end
  end
end
