module Interactor
  class EventCopy < Base

    def main
      check_extraction do
        @event_id = extract_id(
          Mutator::Id.new(params)
        )
      end

      check_current_user
      check_errors(:event)
      check_errors(:copied_event)

      set_response(:event, Presenter::Event.new(copied_event).event)
    end

    private

    def event
      @event ||= Model::Event.where(id: @event_id).first
    end

    def copied_event
      @copied_event ||= Model::Event.create(@copied_attributes)
    end

    def copied_attributes
      @copied_attributes ||= event.attributes.delete_if { |k,v| k == 'id'}
    end
  end
end
