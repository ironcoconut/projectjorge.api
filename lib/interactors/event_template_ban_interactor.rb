module Interactor
  class EventTemplateBan < Base

    def validate
      v = Validator::Base.new(params)
      v.coerce_string('id')
      v.all_present('id')
      @event_template_id = extract(v)['id']

      v2 = Validator::Base.new(body)
      v2.coerce_string('handle', 'email', 'phone', 'user_id')
      v2.some_present('handle', 'email', 'phone', 'user_id')
      @banned_data = extract(v2)
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

    def banned
      @banned ||= Model::User.where(@banned_data).first
    end

    def banishment
      @banishment ||= Model::UserEventTemplate.
        find_or_create_by(
          event_template_id: event_template.event_template_id, 
          user_id: banned.user_id
        )
    end

    def authorize
      check_current_user
      check_errors(event_template)
      check_errors(event_admin)
      check_errors(banned)
      check_errors(banishment)
    end

    def main
      banishment.banned = true
      banishment.save
      check_errors(banishment)
    end

    def present
      set_response(:event_template_admin, Presenter::User.new(banned).friend)
    end
  end
end
