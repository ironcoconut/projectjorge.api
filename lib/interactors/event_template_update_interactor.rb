module Interactor
  class EventTemplateUpdate < Base

    def validate
      v = Validator::Base.new(body)
      v.coerce_string('id', 'name', 'type', 'recurring', 'avatar')
      v.coerce_int('degrees')
      @event_template_data = extract(v)

      v2 = Validator::Base.new(params)
      v2.coerce_string('id')
      v2.all_present('id')
      @event_id = extract(v2)['id']
    end

    def event_template
      @event_template ||= Model::EventTemplate.find(@event_id)
    end

    def event_admin
      @event_admin ||= Model::UserEventTemplate.
        where(
          event_template_id: @event_id, 
          user_id: current_user.user_id, 
          admin: true
        ).first
    end

    def updated_template
      @updated_template ||= event_template.update(@event_template_data)
    end

    def authorize
      check_current_user
      check_errors(event_template)
      check_errors(event_admin)
      check_true(updated_template, "Unable to update event template")
    end

    def main
    end

    def present
      set_response(:event_template, Presenter::EventTemplate.new(event_template).event_template)
    end
  end
end
