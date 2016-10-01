module Interactor
  class UserFind < Base

    def main
      check_current_user

      set_response(:user, Presenter::User.new(current_user.model).user_token)
    end

    def user
      # Should return all friends of current user, perhaps?
      # @user ||= Model::User.where(@user_data).first || current_user
    end

    def relation
      # TODO: update to use Graph::User
      # @relation ||= true
    end
  end
end
