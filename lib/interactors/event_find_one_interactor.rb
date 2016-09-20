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
      (admin_ids & blocked_ids).empty?
    end

    def admin_ids
      @admin_ids ||= Model::RSVP.
        where(
          event_id: event.id, 
          admin: true
        ).
        pluck(:pollux_id)
    end

    def blocked_ids
      @blocked_ids ||= Graph::User.blocked_relations(current_user.id).map(&:id)
    end
  end
end
