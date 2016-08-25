module Interactor
  class UserUpdate < Base

    def validate
      v = Validator::Base.new(body)
      v.coerce_string('handle', 'email', 'password', 'phone', 'avatar', 'contact_frequency')
      v.coerce_bool('prefer_email', 'prefer_phone')
      v.some_present('handle', 'email', 'password', 'phone', 'avatar', 'prefer_email', 'prefer_phone', 'contact_frequency')
      @user_data = extract(v)
    end

    def authorize
      check_current_user
    end

    def main
      current_user.update(@user_data)
      if current_user.errors.present?
        @errors.concat(user.errors.full_messages)
      end
    end

    def present
      set_response(:user, Presenter::User.new(current_user).user)
    end
  end
end
