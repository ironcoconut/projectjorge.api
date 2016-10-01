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
        yours: format(current_user.events),
        friends: format(current_user.friends_events),
        friends_of_friends: format(current_user.friends_of_friends_events),
        public: format(current_user.public_events)
      }
    end

    def format events
      events.map { |evt| Presenter::Event.new(evt).event }
    end
  end
end
