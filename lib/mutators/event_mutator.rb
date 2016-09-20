module Mutator
  class Event < Base
    attribute :name, String
    normalize :name

    attribute :avatar, String
    normalize :avatar

    attribute :description, String
    normalize :description

    attribute :location, Array[Float]
    normalize :location

    attribute :degrees, Integer
    normalize :degrees

    attribute :starts_at, DateTime
    normalize :starts_at

    attribute :ends_at, DateTime
    normalize :ends_at

    set_check_some('name', 'description')
  end
end
