module Interactor
  class EventTemplateBlock < Base

    def validate
      v = Validator::Base.new(params)
      v.coerce_string('id')
      v.all_present('id')
      @event_template_id = extract(v)['id']
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

    def authorize
      check_current_user
      check_errors(event_template)
      check_errors(relation)
    end

    def main
      relation.blocked = true
      relation.save
      check_errors(relation)
    end

    def present
      set_response(:event_template_blocked, Presenter::EventTemplate.new(event_template).event_template)
    end
  end
end
