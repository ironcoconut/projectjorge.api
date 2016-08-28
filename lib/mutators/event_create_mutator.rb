module Mutator
  class EventCreate < Base
    attribute :description, String
    normalize :description

    attribute :image, String
    normalize :image

    attribute :location, Array[Float]
    normalize :location
  end
end
