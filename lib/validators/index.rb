require 'set'

class UserValidator
  attr_reader :data, :body, :errors
  def initialize(body)
    @body = body
    @_items = Set.new
    @errors = []
  end
  def login
    coerce_string('handle', 'email', 'phone', 'password') 
    all_present('password')
    some_present('handle', 'email', 'phone')
    build_hash('handle', 'email', 'phone', 'password')
  end
  def register
    coerce_string('handle', 'email', 'password', 'phone', 'avatar', 'contact_frequency')
    coerce_bool('prefer_email', 'prefer_phone')
    some_present('handle', 'email', 'phone')
    all_present('password')
    build_hash('handle', 'email', 'password', 'phone', 'avatar', 'prefer_email', 'prefer_phone', 'contact_frequency')
  end
  def find
    coerce_string('handle')
    build_hash('handle')
  end
  def update
    coerce_string('handle', 'email', 'password', 'phone', 'avatar', 'contact_frequency')
    coerce_bool('prefer_email', 'prefer_phone')
    some_present('handle', 'email', 'password', 'phone', 'avatar', 'prefer_email', 'prefer_phone', 'contact_frequency')
    build_hash('handle', 'email', 'password', 'phone', 'avatar', 'prefer_email', 'prefer_phone', 'contact_frequency')
  end
  def friend
    coerce_string('handle', 'email', 'phone')
    some_present('handle', 'email', 'phone')
    build_hash('handle', 'email', 'phone')
  end
  def block
    friend
  end

  private

  def coerce_string *items
    items.each do |i|
      if !body[i].nil?
        # need to capture error or change
        @body[i] = body[i].to_str
      end
      @_items.add(i)
    end
  end
  def coerce_bool *items
    items.each do |i|
      if !body[i].nil?
        @body[i] = !!body[i]
      end
      @_items.add(i)
    end
  end
  def all_present *items
    return if items.map { |i| !body[i].nil? }.all?
    @errors.push("All not present: #{items.join(', ')}")
  end
  def some_present *items
    return if items.map { |i| !body[i].nil? }.any?
    @errors.push("None present: #{items.join(', ')}")
  end
  def build_hash *items
    @errors.push("Unsafe items in hash: #{unsafe_items(items).join(', ')}") if !unsafe_items(items).empty?
    @data = items.map { |i| body[i].nil? ? nil : [i, body[i]] }.compact.to_h
    return self
  end
  def unsafe_items(items)
    items - @_items.to_a
  end
end
