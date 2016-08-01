require 'json'
require './test/test_helper.rb'

class StatsTest < PJTest
  def error_message
    "#{last_response.status}: #{last_response.body}"
  end
  def body
    @body ||= JSON.parse(last_response.body)
  end
  def test_login_with_email
    secret = PJApi.settings.secret
    user = create_user
    post '/users/login', { email: user.email, password: "123456" }.to_json
    assert last_response.ok?, error_message
    token = rack_mock_session.cookie_jar['user_token']
    user_hash = JWT.decode(token, secret, true, { :algorithm => 'HS256' }).first
    assert user.user_id === user_hash['data']['user_id'], 'user ids do not match'
  end
  def test_login_with_handle
    secret = PJApi.settings.secret
    user = create_user
    post '/users/login', { handle: user.handle, password: "123456" }.to_json
    assert last_response.ok?, error_message
    token = rack_mock_session.cookie_jar['user_token']
    user_hash = JWT.decode(token, secret, true, { :algorithm => 'HS256' }).first
    assert user.user_id === user_hash['data']['user_id'], 'user ids do not match'
  end
  def test_user_registration
    user_hash = {
      handle: 'johjon',
      email: 'bob@ecom',
      password: '123456',
      phone: '5555555555',
      avatar: 'avatar.jpg',
      prefer_email: true,
      prefer_phone: false,
      contact_frequency: 'weekly'
    }
    post "users", user_hash.to_json
    assert last_response.ok?, error_message
    assert body['handle'] === user_hash['handle'], 'handles do not match'
  end
  def test_user_read_from_handle
    user = login_user
    get "users"
    assert last_response.ok?, error_message
    assert body['data']['handle'] === user.handle, 'handles do not match'
  end
  def test_user_update
    login_user
    put "users", {prefer_email: true}.to_json
    assert last_response.ok?, error_message
  end
  def test_user_friend
    data = {email: 'tim@t.com'}
    user = login_user
    post "users/friend", data.to_json
    assert last_response.ok?, error_message
  end
  def test_user_block
    data = {email: 'tim@t.com'}
    login_user
    post "users/block", data.to_json
    assert last_response.ok?, last_response.status
  end
end
