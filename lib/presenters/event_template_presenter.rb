module Presenter
  class EventTemplate < Base
    def event_template
      build_hash('name')
    end
  end
end
