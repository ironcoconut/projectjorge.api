module Interactor
  class EventTemplateAppoint < Base

    def validate
      v = Validator::Base.new(params)
      v.coerce_string('id')
      v.all_present('id')
      @event_template_id = extract(v)['id']

      v2 = Validator::Base.new(body)
      v2.coerce_string('handle', 'email', 'phone', 'user_id')
      v2.some_present('handle', 'email', 'phone', 'user_id')
      @appointee_data = extract(v2)
    end

    def event_template
      @event_template ||= Model::EventTemplate.where(event_template_id: @event_template_id).first
    end

    def event_admin
      @event_admin ||= Model::UserEventTemplate.
        where(event_template_id: @event_template_id).
        where(user_id: current_user.user_id).
        where("blocked IS NOT TRUE").
        where("banned IS NOT TRUE").
        where("admin IS TRUE").
        first
    end

    def appointee
      @appointee ||= Model::User.where(@appointee_data).first
    end

    def appointment
      @appointment ||= Model::UserEventTemplate.
        find_or_create_by(
          event_template_id: event_template.event_template_id, 
          user_id: appointee.user_id
        )
    end

    def authorize
      check_current_user
      check_errors(event_template)
      check_errors(event_admin)
      check_errors(appointee)
      check_errors(appointment)
    end

    def main
      appointment.admin = true
      appointment.save
      check_errors(appointment)
    end

    def present
      set_response(:event_template_admin, Presenter::User.new(appointee).friend)
    end
  end
end
