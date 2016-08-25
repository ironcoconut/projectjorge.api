module Interactor
  class EventTemplateCreate < Base

    def validate
      v = Validator::Base.new(body)
      v.coerce_string('name', 'type', 'recurring', 'avatar')
      v.coerce_int('degrees')
      v.all_present('name')
      @event_template_data = extract(v)
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

    def authorize
      check_current_user
      check_errors(event_template)
      check_errors(event_admin)
    end

    def main
    end

    def present
      set_response(:event_template, Presenter::EventTemplate.new(event_template).event_template)
    end
  end
end
