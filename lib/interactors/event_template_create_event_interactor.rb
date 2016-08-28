module Interactor
  class EventTemplateCreateEvent < Base

    def main
      check_extraction do
        @event_data = extract(
          Mutator::EventCreate.new(body)
        )
        @event_template_id = extract(
          Mutator::Id.new(params)
        )[:id]
      end

      check_current_user
      check_errors(:event_template)
      check_errors(:event_admin)
      check_errors(:event)

      set_response(:event_template, Presenter::EventTemplate.new(event_template).event_template)
    end

    private

    def event_template
      @event_template ||= Model::EventTemplate.where(event_template_id: @event_template_id).first
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
  end
end