module Graph
  class User < Base
    def self.block(castor_id, pollux_id)
      create_relationship(castor_id, pollux_id, :BLOCKED)
    end

    def self.invite(castor_id, pollux_id)
      create_relationship(castor_id, pollux_id, :INVITED)
    end

    def self.follow(castor_id, pollux_id)
      create_relationship(castor_id, pollux_id, :FOLLOWED)
    end

    def self.add(castor_id, pollux_id)
      create_relationship(castor_id, pollux_id, :ADDED)
    end

    def self.friend(castor_id, pollux_id)
      create_relationship(castor_id, pollux_id, :FRIENDED)
    end

    def self.create_relationship(castor_id, pollux_id, relationship)
      connection.query("merge (c:User {id: '#{castor_id}'}) 
                        merge (p:User {id: '#{pollux_id}'}) 
                        merge (c)-[:#{relationship.to_s.upcase}]->(p)
                        return c.id as castor_id, p.id as pollux_id")
    end
    def self.load_relations(id, min=0, max=2)
      connection.query("match p=(b {id:'#{id}'})-[*#{min}..#{max}]-(m) 
                        where not ((b)-[:BLOCKED*]-(m)) 
                        return distinct m.id as id, min(length(p)) as l 
                        order by l")
    end
    def self.blocked_relations(id)
      connection.query("match (b {id:'#{id}'})-[:BLOCKED*]-(m) 
                        return distinct m.id as id")
    end
    # TODO: query to find min distance between 2 users

    attr_reader :user_id

    def initialize(token)
      @user_id = token[:id]
    end

    def friends_ids
      @friends_ids ||= relations_ids.select { |i| i.l == 1 }.map(&:id)
    end

    def friends_of_friends_ids
      @friends_of_friends_ids ||= relations_ids.select { |i| i.l == 2 }.map(&:id)
    end

    def relations_ids
      @user_relations ||= self.class.load_relations(user_id).to_a
    end

    def blocked_ids
      @blocked_ids ||= self.class.blocked_relations(user_id).map(&:id)
    end
  end
end
