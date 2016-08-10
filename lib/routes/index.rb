require 'sinatra/base'
require 'sinatra/json'
require "sinatra/namespace"
require "sinatra/cookies"
require "rack/contrib"
require "json"
require 'yaml'
require 'jwt'

class PJApi < Sinatra::Base
  use Rack::PostBodyContentTypeParser
  register Sinatra::Namespace
  helpers Sinatra::Cookies

  set :secret, YAML::load_file(File.join(__dir__, '../../config/settings.yml'))['secret']

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
      @token ||= cookies[:user_token].nil? ? nil : JWT.decode(cookies[:user_token], PJApi.settings.secret, true, { :algorithm => 'HS256' }).first
    end
    def set_token(user)
      response.set_cookie(
        'user_token', 
        {
          value: JWT.encode(user, PJApi.settings.secret, 'HS256'),
          max_age: "7776000"
        }
      )
    end
    def base_action(interactor)
      if interactor.success?
        json interactor.response
      else
        status 401
        body interactor.errors
      end
    end
    def user_auth(interactor)
      if interactor.success?
        set_token(interactor.response)
        json interactor.response
      else
        status 401
        body interactor.errors
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
    get()           { base_action(Interactor::UserFind.new(interactor_data)) }
    put()           { base_action(Interactor::UserUpdate.new(interactor_data)) }
    post()          { user_auth(Interactor::UserRegistration.new(interactor_data)) }
  end

  namespace "/event-templates" do
    post("/:id/appoint") { base_action(Interactor::EventTemplateAppoint.new(interactor_data)) }
    post("/:id/block")   { base_action(Interactor::EventTemplateBlock.new(interactor_data)) }
    post("/:id/ban")     { base_action(Interactor::EventTemplateBan.new(interactor_data)) }
    post("/:id/follow")  { base_action(Interactor::EventTemplateFollow.new(interactor_data)) }
    post("/:id/invite")  { base_action(Interactor::EventTemplateInvite.new(interactor_data)) }
    get("/:id")          { base_action(Interactor::EventTemplateFindOne.new(interactor_data)) }
    post("/:id")         { base_action(Interactor::EventTemplateUpdate.new(interactor_data)) }
    get()                { base_action(Interactor::EventTemplateFind.new(interactor_data)) }
    put()                { base_action(Interactor::EventTemplateCreate.new(interactor_data)) }
  end
end
