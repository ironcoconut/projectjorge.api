module Interactor
  class EventTemplateFind < Base

    def validate
    end

    def event_template_query
      Model::EventTemplate.
        joins("INNER JOIN user_event_templates as uet on uet.event_template_id = event_templates.event_template_id").
        where("uet.user_id = ?", current_user.id).
        where("uet.blocked IS NOT TRUE").
        where("uet.banned IS NOT TRUE").
        where("uet.admin IS TRUE OR uet.followed IS TRUE")
    end

    def event_templates
      @event_templates ||= event_template_query
    end

    def authorize
      check_current_user
      event_templates.each { |et| check_errors(et) }
    end

    def main
    end

    def present
      presenters = event_templates.map { |et| Presenter::EventTemplate.new(et).event_template }
      set_response(:event_templates, presenters)
    end
  end
end
