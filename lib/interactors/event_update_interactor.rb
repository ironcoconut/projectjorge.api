module Interactor
  class EventUpdate < Base

    def main
      check_extraction do
        @event_id = extract_id(
          Mutator::Id.new(params)
        )
        @event_data = extract(
          Mutator::Event.new(body)
        )
      end

      check_current_user
      check_errors(:event)
      check_true(:user_admin)
      check_errors(:update_event)

      set_response(:event, event)
    end

    private

    def event
      @event ||= Model::Event.where(id: @event_id).first
    end

    def user_admin
      @user_admin ||= Model::RSVP.where(event_id: event.id, pollux_id: current_user.id, admin: true).any?
    end

    def update_event
      event.update(@event_data)
      return event
    end
  end
end
