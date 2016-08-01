ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'database_cleaner'
require './lib/index'
require 'json'
require 'pry'


DatabaseCleaner.strategy = :truncation

class PJTest < MiniTest::Test
  include Rack::Test
  include Rack::Test::Methods

  def app
    PJApi
  end

  def before_teardown
    DatabaseCleaner.clean
    super
  end

  def create_user opts={}
    @@user_count ||= 0
    @@user_count += 1
    default_opts = { handle: "g#{@@user_count}", 
                     email: "g@#{@@user_count}.com",
                     password: "123456" }
    return UserModel.create!(default_opts.merge(opts))
  end

  def login_user user=nil, pwd='123456'
    user ||=create_user
    post '/users/login', {email: user.email, password: pwd }.to_json
    set_cookie("user_token=#{rack_mock_session.cookie_jar['user_token']}")
    return user
  end
end
