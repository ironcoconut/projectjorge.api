module Presenter
  class User < Base
    def user_token
      build_hash('id', 'handle')
    end
    def user
      build_hash('handle', 'email', 'phone', 'avatar', 'prefer_email', 'prefer_phone', 'contact_frequency')
    end
    def friend
      build_hash('handle')
    end
    def block
      build_hash('handle')
    end
  end
end
