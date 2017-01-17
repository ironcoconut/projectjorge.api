module Presenter
  class Event < Base
    def event
      hash = build_hash('id', 'name', 'avatar', 'description', 'location', 'degrees', 'starts_at', 'ends_at', 'created_at', 'updated_at')
      hash['date'] = @data.starts_at.strftime("%a, %b %-d, %Y")
      hash['start_time'] = @data.starts_at.strftime("%l:%M %P")
      hash['end_time'] = @data.ends_at.strftime("%l:%M %P")
      hash['time'] = "#{hash['start_time']} - #{hash['end_time']}"
      hash
    end

    def list_element
      hash = build_hash('id', 'admin', 'name', 'avatar', 'description', 'location', 'degrees')
      ['starts_at', 'ends_at', 'created_at', 'updated_at'].each do |item|
        hash[item] = @data.send(item).strftime("%a, %b %-d, %Y at %l:%M %P")
      end
      hash
    end
  end
end
