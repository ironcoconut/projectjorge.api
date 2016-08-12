require 'json'
require './test/test_helper.rb'

class EventIntegrationTest < PJTest
  def test_create_new
    login_user
    data = {
      name: 'event',
      recurring: 'weekly',
      avatar: 'some url',
      degrees: 2,
      description: 'aweluck',
      location: [1,2],
      image: 'some url'
    }
    put '/events', data.to_json
    assert last_response.ok?, error_message
  end

  def test_create_from_template
  end

  def test_read_one
  end

  def test_read
  end

  def test_update
  end

  def test_block
  end

  def test_accept
  end
end
