class UserPolicy
  attr_reader :token, :data, :errors
  def initialize(token, data)
    @token = token
    @data = data
    @errors = []
  end
  def login
    check('user')
    return self
  end
  def register
    check('user')
    return self
  end
  def find
    present('current_user', "Not logged in.")
    present('user', "Missing user.")
    present('relation', "Forbidden.")
    return self
  end
  def update
    present('current_user', "Not logged in.")
    return self
  end
  def friend
    present('current_user', "Not logged in.")
    check('user')
    return self
  end
  def block
    present('current_user', "Not logged in.")
    check('user')
    return self
  end

  private

  def present(key, msg)
    @errors.push(msg) if data[key].nil?
  end
  def check(key)
    if !key.nil? && !data[key].nil?
      @errors.concat(data[key].errors.full_messages)
    else
      @errors.push("Unable to find: #{key}")
    end
  end
end
