class Validator
  attr_reader :body, :results, :errors
  def initialize body
    @body = body
    @results = {}
    @errors = []
  end

  def coerce_string *items
    items.each do |i|
      if !@body[i].nil?
        # need to capture error or change
        @results[i] = @body[i].to_str
      end
    end
  end
  def coerce_bool *items
    items.each do |i|
      if !@body[i].nil?
        @results[i] = !!@body[i]
      end
    end
  end
  def coerce_int *items
    items.each do |i|
      if !@body[i].nil?
        @results[i] = Integer(@body[i])
      end
    end
  end
  def all_present *items
    if (items - @results.keys).length != 0
      @errors.push("All not present: #{items.join(', ')}")
    end
  end
  def some_present *items
    if items.length === (items - @results.keys).length
      @errors.push("None present: #{items.join(', ')}")
    end
  end
end
