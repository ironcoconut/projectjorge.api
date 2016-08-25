module Interactor
  class UserFind < Base

    def validate
      v = Validator::Base.new(body)
      v.coerce_string('handle')
      @user_data = extract(v)
    end

    def user
      @user ||= Model::User.where(@user_data).first || current_user
    end

    def relation
      @relation ||= Model::UserRelation.related(current_user, user)
    end

    def authorize
      check_current_user
      check_errors(user, 'Unable to find user')
      check_true(relation, 'Unable to find user')
    end

    def main
    end

    def present
      set_response(:user, Presenter::User.new(user).user_token)
    end
  end
end
