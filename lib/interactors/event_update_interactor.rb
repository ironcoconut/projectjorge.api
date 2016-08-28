module Interactor
  class EventUpdate < Base

    def main
      check_extraction do
        @event_id = extract(
          Mutator::Id.new(params)
        )[:id]
        @event_data = extract(
          Mutator::EventUpdate.new(body)
        )
      end

      check_current_user
      check_errors(:event)
      check_present(:user_event_template)
      check_true(:user_not_banned)
      check_true(:user_admin)
      check_errors(:update_event)

      set_response(:event, event)
    end

    private

    def event
      @event ||= Model::Event.where(event_id: @event_id).first
    end

    def user_event_template
      @user_event_template = Model::UserEventTemplate.
        where(
          event_template_id: event.event_template_id, 
          user_id: current_user.user_id
        ).
        first
    end

    def user_not_banned
      @user_not_banned = !user_event_template.banned?
    end

    def user_admin
      @user_admin ||= user_event_template.admin?
    end

    def update_event
      event.update(@event_data)
      return event
    end
  end
end
