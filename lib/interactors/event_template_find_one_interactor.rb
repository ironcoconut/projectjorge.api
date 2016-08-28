module Interactor
  class EventTemplateFindOne < Base

    def main
      check_extraction do
        @event_template_id = extract(
          Mutator::Id.new(params)
        )[:id]
      end

      check_current_user
      check_errors(:event_template)

      set_response(:event_template, event_template)
    end

    private

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
  end
end
