module Interactor
  class EventTemplateBan < Base

    def main
      check_extraction do
        @event_template_id = extract(
          Mutator::Id.new(params)
        )[:id]
        @banned_data = extract(
          Mutator::UserFind.new(body)
        )
      end

      check_current_user
      check_errors(:event_template)
      check_errors(:event_admin)
      check_errors(:banned)
      check_errors(:banishment)
      check_errors(:ban)

      set_response(:event_template_admin, Presenter::User.new(banned).friend)
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

    def ban
      banishment.banned = true
      banishment.save
      banishment
    end
  end
end
