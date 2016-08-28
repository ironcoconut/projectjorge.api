module Presenter
  class Base
    def initialize data
      @data = data
    end

    private

    def build_hash *items
      mapped = items.map do |i| 
        item = @data.send(i)
        if !item.nil?
          [i, item]
        else
          nil
        end
      end
      return mapped.compact.to_h
    end
  end
end
