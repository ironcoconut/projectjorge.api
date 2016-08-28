module Interactor
  class EventTemplateBlock < Base

    def main
      check_extraction do
        @event_template_id = extract(
          Mutator::Id.new(params)
        )[:id]
      end

      check_current_user
      check_errors(:event_template)
      check_errors(:relation)
      check_errors(:block)

      set_response(:event_template_blocked, Presenter::EventTemplate.new(event_template).event_template)
    end

    def event_template
      @event_template ||= Model::EventTemplate.where(event_template_id: @event_template_id).first
    end

    def relation
      @relation ||= Model::UserEventTemplate.
        find_or_create_by(
          event_template_id: event_template.event_template_id, 
          user_id: current_user.user_id
        )
    end

    def block
      relation.blocked = true
      relation.save
      relation
    end
  end
end
