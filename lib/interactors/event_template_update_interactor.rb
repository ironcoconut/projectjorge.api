module Interactor
  class EventTemplateUpdate < Base

    def main
      check_extraction do
        @event_template_data = extract(
          Mutator::EventTemplateUpdate.new(body)
        )
        @event_template_id = extract(
          Mutator::Id.new(params)
        )[:id]
      end

      check_current_user
      check_errors(:event_template)
      check_errors(:event_admin)
      check_errors(:update_template)

      set_response(:event_template, Presenter::EventTemplate.new(event_template).event_template)
    end

    private

    def event_template
      @event_template ||= Model::EventTemplate.find(@event_template_id)
    end

    def event_admin
      @event_admin ||= Model::UserEventTemplate.
        where(
          event_template_id: @event_template_id, 
          user_id: current_user.user_id, 
          admin: true
        ).first
    end

    def update_template
      event_template.update(@event_template_data)
      event_template
    end
  end
end
