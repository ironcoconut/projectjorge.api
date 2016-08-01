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
        token: token,
      }
    end
    def request_body() 
      @request_body ||= JSON.parse(request.body.read) if !request.body.nil?
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
    def user_action(action, data=nil)
      interactor = UserInteractor.new(data || interactor_data).send(action)
      if interactor.success?
        json interactor.response
      else
        status 401
        body interactor.errors
      end
    end
    def user_auth(action, data=nil)
      interactor = UserInteractor.new(data || interactor_data).send(action)
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
    post("/login")  { user_auth(:login) }
    post("/friend") { user_action(:friend) }
    post("/block")  { user_action(:block) }
    get()           { user_action(:find, {body: {}, token: token}) }
    put()           { user_action(:update) }
    post()          { user_auth(:register) }
  end
end
