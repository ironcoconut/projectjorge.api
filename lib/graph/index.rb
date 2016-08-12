require 'neo4j-core'
require 'yaml'

module Graph
  class Base
    def self.config=(config)
      @config=config
    end
    def self.establish_connection (env)
      config = @config[env]
      path = config['path']
      auth = {basic_auth: {username: config['username'], password: config['password']}}
      @@connection = Neo4j::Session.open(:server_db, path, auth)
    end
    def self.connection
      @@connection
    end
  end
end

Graph::Base.config = YAML::load_file(File.join(__dir__, '../../config/graph.yml'))
Graph::Base.establish_connection(ENV['RACK_ENV'] || 'development')

class UserGraph < Graph::Base
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
end
