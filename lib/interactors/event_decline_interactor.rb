module Interactor
  class EventDecline < Base

    def main
      check_extraction do
        @event_id = extract_id(
          Mutator::Id.new(params)
        )
      end

      check_current_user
      check_errors(:rsvp)
      check_errors(:decline_rsvp)

      set_response(:rsvp, Presenter::RSVP.new(rsvp).rsvp)
    end

    private

    def rsvp
      @rsvp ||= Model::RSVP.where(event_id: @event_id, pollux_id: current_user.id).first_or_create
    end

    def decline_rsvp
      rsvp.accepted = false
      rsvp.declined = true
      rsvp.save
      rsvp
    end
  end
end
