module Interactor
  class EventInvite < Base

    def main
      check_extraction do
        @event_id = extract_id(
          Mutator::Id.new(params)
        )
        @user_data = extract(
          Mutator::UserFind.new(body)
        )
      end

      check_current_user
      check_errors(:rsvp)
      check_errors(:guest)
      check_true(:event_admin)
      check_errors(:invitation)

      set_response(:rsvp, Presenter::RSVP.new(invitation).rsvp)
    end

    private

    def rsvp
      @rsvp ||= Model::RSVP.where(event_id: @event_id, pollux_id: current_user.id).first
    end

    def guest
      @guest ||= Model::User.find_or_create_by(@user_data)
    end

    def event_admin
      rsvp.admin?
    end

    def invitation
      @invitation ||= Model::RSVP.create(castor_id: current_user.id, pollux_id: guest.id, event_id: @event_id)
    end
  end
end
