module Interactor
  class EventFind < Base

    def main
      check_current_user

      set_response(:events, events)
    end

    private

    def events
      @events ||= {
        yours: format(your_events),
        friends: format(friends_events),
        friends_of_friends: format(friends_of_friends_events),
        public: format(public_events)
      }
    end

    def format events
      events.map { |evt| Presenter::Event.new(evt).event }
    end

    def your_events
      @your_events ||= Model::Event.
        joins("INNER JOIN rsvps on rsvps.event_id = events.id").
        where("rsvps.declined IS NOT TRUE").
        where("rsvps.pollux_id = ?", current_user.id).
        select("events.id").
        distinct
    end

    def friends_events
      @friends_events ||= friends_ids.present? ? load_friends_events : []
    end

    def load_friends_events
      Model::Event.
        joins("INNER JOIN rsvps on rsvps.event_id = events.id").
        where("rsvps.admin IS TRUE").
        where("rsvps.pollux_id in (?)", friends_ids).
        where("events.degrees = 1")
    end

    def friends_of_friends_events
      @friends_of_friends_events ||= user_relation_ids.present? ? load_friends_of_friends_events : []
    end

    def load_friends_of_friends_events
      @friends_of_friends_events ||= Model::Event.
        joins("INNER JOIN rsvps on rsvps.event_id = events.id").
        where("rsvps.admin IS TRUE").
        where("rsvps.pollux_id in (?)", user_relation_ids.map(&:id)).
        where("events.degrees = 2")
    end

    def public_events
      @public_events ||= Model::Event.
        where("events.degrees IS NULL")
    end

    def user_relation_ids
      @user_relations ||= Graph::User.load_relations(current_user.id).to_a
    end

    def friends_ids
      @friends_ids ||= user_relation_ids.select { |i| i.l == 1 }.map(&:id)
    end
  end
end
