module Interactor
  class EventTemplateFollow < Base

    def validate
      v = Validator.new(params)
      v.coerce_string('id')
      v.all_present('id')
      @event_template_id = extract(v)['id']
    end

    def event_template
      @event_template ||= EventTemplateModel.where(event_template_id: @event_template_id).first
    end

    def relation
      @relation ||= UserEventTemplateModel.
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
      relation.followed = true
      relation.save
      check_errors(relation)
    end

    def present
      set_response(:event_template_blocked, EventTemplatePresenter.new(event_template).event_template)
    end
  end
end
