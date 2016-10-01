module Interactor
  class EventFindOne < Base

    def main
      check_extraction do
        @event_id = extract_id(
          Mutator::Id.new(params)
        )
      end

      check_current_user
      check_errors(:event)
      check_true(:not_blocked)

      set_response(:event, Presenter::Event.new(event).event)
    end

    private

    def event
      @event ||= Model::Event.where(id: @event_id).first
    end

    def not_blocked
      (admin_ids & current_user.blocked_ids).empty?
    end

    def admin_ids
      @admin_ids ||= Model::RSVP.event_admin_ids(event)
    end
  end
end
