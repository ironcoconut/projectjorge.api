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

  # Create event from an existing template occurs in event-templates

  def test_read_one
    admin = login_user
    event = create_event(admin: admin)
    get "events/#{event.event_id}"
    assert last_response.ok?, error_message
  end

  def test_read
    admin = create_user
    event = create_event(admin: admin)
    user = login_user
    Graph::User.create_relationship(admin.user_id, user.user_id, :FRIENDED)
    get "events"
    assert last_response.ok?, error_message
  end

  def test_update
    admin = login_user
    event = create_event(admin: admin)
    data = {
      description: 'aweluck',
      location: [1,2],
      image: 'some url'
    }
    post "events/#{event.event_id}", data.to_json
    assert last_response.ok?, error_message
  end

  def test_block
  end

  def test_accept
  end

  def test_invite
  end
end
