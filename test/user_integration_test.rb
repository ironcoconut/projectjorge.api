require 'json'
require './test/test_helper.rb'

class UserTest < PJTest
  SECRET = PJConfig.secret

  def assert_login_success(user)
    assert last_response.ok?, error_message

    token = rack_mock_session.cookie_jar['user_token']
    user_hash = JWT.decode(token, SECRET, true, { :algorithm => 'HS256' }).first
    assert user.id === user_hash['data']['id'], 'user ids do not match'
  end

  def test_login_with_email
    user = create_user
    post '/users/login', { identifier: user.email, password: "123456" }.to_json

    assert_login_success(user)
  end
  def test_login_with_handle
    user = create_user
    post '/users/login', { identifier: user.handle, password: "123456" }.to_json

    assert_login_success(user)
  end
  def test_login_with_phone
    user = create_user
    post '/users/login', { identifier: user.phone, password: "123456" }.to_json

    assert_login_success(user)
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
    login_user
    data = {email: 'tim@t.com'}
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
