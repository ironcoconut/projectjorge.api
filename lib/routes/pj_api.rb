module Route
  class PJApi < Sinatra::Base
    use Rack::PostBodyContentTypeParser
    register Sinatra::Namespace
    helpers Sinatra::Cookies

    SECRET = PJConfig.secret

    helpers do
      def interactor_data()
        @interactor_data ||= {
          body: request_body,
          params: params,
          token: token
        }
      end
      def request_body() 
        @request_body ||= begin
                            data = request.body.read
                            if data.present?
                              JSON.parse(data)
                            else
                              {}
                            end
                          end
      end
      def token()
        @token ||= cookies[:user_token].nil? ? nil : JWT.decode(cookies[:user_token], SECRET, true, { :algorithm => 'HS256' }).first
      end
      def set_token(user)
        response.set_cookie(
          'user_token', 
          {
            value: JWT.encode(user, SECRET, 'HS256'),
            max_age: "7776000"
          }
        )
      end
      def base_action(interactor)
        if interactor.success?
          json interactor.response
        else
          status 401
          json interactor.errors
        end
      end
      def user_auth(interactor)
        if interactor.success?
          set_token(interactor.response)
          json interactor.response
        else
          status 401
          json interactor.errors
        end
      end
    end

    before do
      content_type 'application/json'
    end

    after do
      response['Access-Control-Allow-Origin'] = 'http://localhost:8080'
    end

    namespace "/users" do
      post("/login")  { user_auth(Interactor::UserLogin.new(interactor_data)) }
      post("/friend") { base_action(Interactor::UserFriend.new(interactor_data)) }
      post("/block")  { base_action(Interactor::UserBlock.new(interactor_data)) }
      post("/follow") { base_action(Interactor::UserFollow.new(interactor_data)) }
      post("/add")    { base_action(Interactor::UserAdd.new(interactor_data)) }
      get()           { base_action(Interactor::UserFind.new(interactor_data)) }
      put()           { base_action(Interactor::UserUpdate.new(interactor_data)) }
      post()          { user_auth(Interactor::UserRegistration.new(interactor_data)) }
    end

    namespace "/events" do
      post("/:id/invite")  { base_action(Interactor::EventInvite.new(interactor_data)) }
      post("/:id/accept")  { base_action(Interactor::EventAccept.new(interactor_data)) }
      post("/:id/decline") { base_action(Interactor::EventDecline.new(interactor_data)) }
      post("/:id/copy")    { base_action(Interactor::EventCopy.new(interactor_data)) }
      get("/:id")          { base_action(Interactor::EventFindOne.new(interactor_data)) }
      put("/:id")          { base_action(Interactor::EventUpdate.new(interactor_data)) }
      get()                { base_action(Interactor::EventFind.new(interactor_data)) }
      post()               { base_action(Interactor::EventCreate.new(interactor_data)) }
    end
  end
end
