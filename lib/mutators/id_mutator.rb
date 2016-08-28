module Mutator
  class Id < Base
    attribute :id, String
    normalize :id

    set_check_all('id')
  end
end
