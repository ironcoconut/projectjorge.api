module Interactor
  class EventFindOne < Base

    def main
      check_extraction do
        @event_id = extract(
          Mutator::Id.new(params)
        )[:id]
      end

      check_current_user
      check_errors(:event)
      check_errors(:event_template)
      check_true(:user_not_banned)
      check_true(:can_view_event)

      set_response(:event, Presenter::EventTemplate.new(event_template).event_template)
    end

    private

    def event
      @event ||= Model::Event.where(event_id: @event_id).first
    end

    def event_template
      @event_template ||= Model::EventTemplate.where(event_template_id: event.event_template_id).first
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
      @user_not_banned = !(user_event_template.present? && user_event_template.banned?)
    end

    def can_view_event
      user_admin || user_followed || user_related
    end

    def user_admin
      @user_admin ||= user_event_template.present? && user_event_template.admin?
    end

    def user_followed
      @user_followed ||= user_event_template.present? && user_event_template.followed?
    end

    def user_related
      return false if user_relation_ids.empty?

      @related_to_event ||= Model::UserEventTemplate.
        where(
          event_template_id: event.event_template_id, 
          user_id: user_relation_ids
        ).
        where("banned IS NOT TRUE").
        where("admin IS TRUE OR followed IS TRUE").
        exists?
    end

    def user_relation_ids
      @user_relations ||= Graph::User.load_relations(current_user.user_id, 0, event_template.degrees).to_a
    end
  end
end
