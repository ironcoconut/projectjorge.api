module Model
  class RSVP < ActiveRecord::Base
    self.table_name = "rsvps"

    def self.event_admin_ids(event)
      where(
        event_id: event.id, 
        admin: true
      ).
      pluck(:pollux_id)
    end
  end
end
