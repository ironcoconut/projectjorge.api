module Mutator
  class EventUpdate < Base
    attribute :description, String
    normalize :description

    attribute :image, String
    normalize :image

    attribute :location, Array[Float]
    normalize :location

    set_check_some('description', 'image', 'location')
  end
end
