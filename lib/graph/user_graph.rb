module Graph
  class User < Base
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
    # TODO: query to find min distance between 2 users
  end
end
