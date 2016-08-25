module Interactor
  class EventTemplateFindOne < Base

    def validate
      v = Validator::Base.new(params)
      v.coerce_string('id')
      v.all_present('id')
      @event_template_id = extract(v)['id']
    end

    def event_template_query
      Model::EventTemplate.
        joins("INNER JOIN user_event_templates as uet on uet.event_template_id = event_templates.event_template_id").
        where("uet.user_id = ?", current_user.id).
        where("event_templates.event_template_id = ?", @event_template_id).
        where("uet.blocked IS NOT TRUE").
        where("uet.banned IS NOT TRUE").
        where("uet.admin IS TRUE OR uet.followed IS TRUE")
    end

    def event_template
      @event_template ||= event_template_query.first
    end

    def authorize
      check_current_user
      check_errors(event_template)
    end

    def main
    end

    def present
      set_response(:event_template, event_template)
    end
  end
end
