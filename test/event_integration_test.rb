require 'json'
require './test/test_helper.rb'

class EventIntegrationTest < PJTest
  def assert_action_route_ok(action)
    login_user
    event = create_event()
    post "events/#{event.id}/#{action}"
    assert last_response.ok?, error_message
  end

  def test_create
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
    post '/events', data.to_json
    assert last_response.ok?, error_message
  end

  def test_read_one
    admin = login_user
    rsvp = create_event_admin_rsvp(admin)
    get "events/#{rsvp.event_id}"
    assert last_response.ok?, error_message
  end

  def test_read
    admin = create_user
    create_event_admin_rsvp(admin)
    user = login_user
    Graph::User.create_relationship(admin.id, user.id, :FRIENDED)
    get "events"
    assert last_response.ok?, error_message
  end

  def test_update
    admin = login_user
    rsvp = create_event_admin_rsvp(admin)
    data = {
      description: 'aweluck',
      location: [1,2],
      avatar: 'some url'
    }
    put "events/#{rsvp.event_id}", data.to_json
    assert last_response.ok?, error_message
  end

  def test_copy
    assert_action_route_ok('copy')
  end

  def test_accept
    assert_action_route_ok('accept')
  end

  def test_decline
    assert_action_route_ok('decline')
  end

  def test_invite
    admin = login_user
    rsvp = create_event_admin_rsvp(admin)
    data = {
      handle: create_user.handle
    }
    post "events/#{rsvp.event_id}/invite", data.to_json
    assert last_response.ok?, error_message
  end
end
