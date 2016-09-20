module Presenter
  class RSVP < Base
    def rsvp
      build_hash('id', 'castor_id', 'pollux_id', 'event_id', 'accepted', 'declined', 'admin', 'created_at', 'updated_at')
    end
  end
end
