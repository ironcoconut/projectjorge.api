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

  def create_event_admin_rsvp admin=nil, event=nil
    admin ||= create_user
    event ||= create_event
    Model::RSVP.create!(event_id: event.id, pollux_id: admin.id, admin: true)
  end

  def create_rsvp opts={}
    event = opts[:event] || create_event
    castor = opts[:castor] || create_user
    pollux = opts[:pollux] || create_user
    rsvp = opts.
      select { |k| [:accepted, :declined, :admin].include?(k) }.
      merge({event_id: event.id, castor_id: castor.id, pollux_id: pollux.id})
    return Model::RSVP.create!(rsvp)
  end

  def create_event opts={}
    return Model::Event.create!(opts)
  end
end
