module Interactor
  class EventFind < Base

    def main
      check_current_user

      set_response(:events, events)
    end

    private

    # hide blocked public events?

    def events
      @events ||= {
        upcoming: format(current_user.upcoming_events),
        invitations: format(current_user.invitations)
      }
    end

    def format events
      events.map { |evt| Presenter::Event.new(evt).list_element }
    end
  end
end
