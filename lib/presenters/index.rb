class UserPresenter
  def initialize user
    @user = user
  end
  def user_token
    build_hash('user_id', 'handle')
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

  private

  def build_hash *items
    mapped = items.map do |i| 
      item = @user.send(i)
      if !item.nil?
        [i, item]
      else
        nil
      end
    end
    return mapped.compact.to_h
  end
end
