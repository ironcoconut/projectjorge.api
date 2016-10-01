module Interactor
  class EventCreate < Base

    def main
      check_extraction do
        @event_data = extract(
          Mutator::Event.new(body)
        )
      end

      check_current_user
      check_errors(:event)
      check_errors(:admin)

      set_response(:event, Presenter::Event.new(event).event)
    end

    private

    def event
      @event ||= Model::Event.create(@event_data)
    end

    def admin
      @admin ||= Model::RSVP.create(admin:true, accepted:true, pollux_id:current_user.id)
    end
  end
end
