module Mutator
  class EventTemplateUpdate < Base
    attribute :name, String
    normalize :name

    attribute :recurring, String
    normalize :recurring

    attribute :avatar, String
    normalize :avatar

    attribute :type, String
    normalize :type

    attribute :degrees, Integer
    normalize :degrees

    set_check_some('name', 'recurring', 'avatar', 'type', 'degrees')
  end
end
