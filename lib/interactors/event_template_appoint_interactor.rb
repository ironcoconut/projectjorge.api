module Interactor
  class EventTemplateAppoint < Base

    def main
      check_extraction do
        @event_template_id = extract(
          Mutator::Id.new(params)
        )[:id]
        @appointee_data = extract(
          Mutator::UserFind.new(body)
        )
      end

      check_current_user
      check_errors(:event_template)
      check_errors(:event_admin)
      check_errors(:appointee)
      check_errors(:appointment)
      check_errors(:appoint_admin)

      set_response(:event_template_admin, Presenter::User.new(appointee).friend)
    end

    private

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

    def appoint_admin
      appointment.admin = true
      appointment.save
      appointment
    end
  end
end
