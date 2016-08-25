module Model
  class UserRelation < ActiveRecord::Base
    self.table_name = "user_relations"

    def self.related(*a)
      return true
    end
  end
end
