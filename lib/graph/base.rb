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
