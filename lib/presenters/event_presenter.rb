module Presenter
  class Event < Base
    def event
      build_hash('id', 'name', 'avatar', 'description', 'location', 'degrees', 'starts_at', 'ends_at', 'created_at', 'updated_at')
    end
  end
end
