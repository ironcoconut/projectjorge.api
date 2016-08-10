require 'json'
require './test/test_helper.rb'

class EventTemplateIntegrationTest < PJTest
  def test_create
    login_user
    data = {name: 'Weekly BBQ'}
    put '/event-templates', data.to_json
    assert last_response.ok?, error_message
  end
  def test_update
    user = login_user
    data = {frequency: 'weekly'}
    event_template = create_event_template
    create_event_template_admin(event_template, user)
    post "/event-templates/#{event_template.event_template_id}", data.to_json
    assert last_response.ok?, error_message
  end
  def test_read_one
    user = login_user
    event_template = create_event_template
    create_event_template_admin(event_template, user)
    get "/event-templates/#{event_template.event_template_id}"
    assert last_response.ok?, error_message
  end
  def test_read_many
    login_user
    get "/event-templates"
    assert last_response.ok?, error_message
  end
  def test_appoint
    admin = login_user
    event_template = create_event_template
    create_event_template_admin(event_template, admin)
    appointee = create_user
    data = {email: appointee.email}
    post "/event-templates/#{event_template.event_template_id}/appoint", data.to_json
    assert last_response.ok?, error_message
  end
end
