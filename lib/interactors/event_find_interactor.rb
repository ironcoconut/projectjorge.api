module Interactor
  class EventFind < Base

    def main
      check_current_user

      set_response(:events, events.map(&:attributes))
    end

    private

    def events
      @events ||= all_events - banned_events
    end

    def all_events
      # check degree of seperation
      @events ||= Model::Event.
        joins("INNER JOIN user_event_templates uet on uet.event_template_id = events.event_template_id").
        joins("INNER JOIN event_templates et on et.event_template_id = events.event_template_id").
        where("uet.admin IS TRUE OR uet.followed IS TRUE").
        where("uet.blocked IS NOT TRUE OR uet.banned IS NOT TRUE").
        where("(uet.user_id in (?) AND et.degrees = 2) OR
               (uet.user_id in (?) AND et.degrees = 1) OR
               (uet.user_id in (?) AND et.degrees = 0)", 
               user_relation_ids.select { |i| i.l < 3 }.map(&:id), 
               user_relation_ids.select { |i| i.l < 2 }.map(&:id), 
               [current_user.user_id]).
        select("events.event_id").
        distinct
    end

    def banned_events
      @banned_events ||= Model::Event.
        joins("INNER JOIN user_event_templates uet on uet.event_template_id = events.event_template_id").
        where("uet.blocked IS TRUE OR uet.banned IS TRUE").
        where('uet.user_id' => current_user.user_id).
        select('events.event_id').
        distinct
    end

    def user_relation_ids
      @user_relations ||= Graph::User.load_relations(current_user.user_id,).to_a
    end
  end
end
