ENV['RACK_ENV'] = 'test'

# TODO: what is setting verbose to true?
$VERBOSE = false

require 'minitest/autorun'
require 'rack/test'
require 'database_cleaner'
require 'json'
require './scripts/load_lib.rb'

DatabaseCleaner.strategy = :truncation

class PJTest < MiniTest::Test
  include Rack::Test
  include Rack::Test::Methods

  def app
    Route::PJApi
  end

  def before_teardown
    DatabaseCleaner.clean
    Graph::Base.connection.query("MATCH (n) DETACH DELETE n")
    super
  end

  def create_user opts={}
    @@user_count ||= 0
    @@user_count += 1
    default_opts = { handle: "g#{@@user_count}", 
                     email: "g@#{@@user_count}.com",
                     password: "123456" }
    return Model::User.create!(default_opts.merge(opts))
  end

  def login_user user=nil, pwd='123456'
    user ||=create_user
    post '/users/login', {email: user.email, password: pwd }.to_json
    set_cookie("user_token=#{rack_mock_session.cookie_jar['user_token']}")
    return user
  end

  def error_message
    "#{last_response.status}: #{last_response.body}"
  end

  def body
    @body ||= JSON.parse(last_response.body)
  end

  def create_event_template opts={}
    @@et_count ||= 0
    @@et_count += 1
    default_opts = { name: "et#{@@et_count}", degrees: 2 }
    return Model::EventTemplate.create!(default_opts.merge(opts))
  end

  def create_event_template_admin event, user
    return Model::UserEventTemplate.create!(admin: true, event_template_id: event.event_template_id, user_id: user.user_id)
  end

  def create_event opts={}
    event_template = opts[:event_template] || create_event_template
    admin = opts[:admin] || create_user
    create_event_template_admin(event_template, admin)
    return Model::Event.create!(event_template_id: event_template.event_template_id)
  end
end
