module Interactor
  class EventCreate < Base

    def validate
      v = Validator::Base.new(body)
      v.coerce_string('description', 'image')
      v.coerce_point('location')
      @event_data = extract(v)

      v2 = Validator::Base.new(body)
      v2.coerce_string('name', 'recurring', 'avatar')
      v2.coerce_int('degrees')
      v2.all_present('name')
      @event_template_data = extract(v2)
    end

    def event_template
      @event_template ||= Model::EventTemplate.create(@event_template_data)
    end

    def event_admin
      @event_admin ||= Model::UserEventTemplate.
        create(
          event_template_id: event_template.event_template_id, 
          user_id: current_user.user_id, 
          admin: true
        )
    end

    def event
      @event ||= Model::Event.create(@event_data.merge({event_template_id: event_template.event_template_id}))
    end

    def authorize
      check_current_user
      check_errors(event_template)
      check_errors(event_admin)
      check_errors(event)
    end

    def main
    end

    def present
      set_response(:event_template, Presenter::EventTemplate.new(event_template).event_template)
    end
  end
end
