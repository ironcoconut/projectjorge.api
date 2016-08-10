module Interactor
  class Base
    attr_reader :response, :errors, :token, :body, :params

    def validate
      raise "Please include a validate function in #{self.class.name}"
    end

    def authorize
      raise "Please include an authorize function in #{self.class.name}"
    end

    def main
      raise "Please include a main function in #{self.class.name}"
    end

    def present
      raise "Please include a present function in #{self.class.name}"
    end

    def success?
      errors.empty? && response.present?
    end

    private

    def initialize(opts)
      @token = opts[:token]
      @body = opts[:body]
      @params = opts[:params]
      @errors = []

      [:validate, :authorize, :main, :present].each { |i| send(i) if @errors.empty? }
    end

    def extract validator
      @errors.concat(validator.errors)
      validator.results
    end

    def check_present(item, msg)
      return if @errors.present?
      @errors.push(msg) if item.nil?
    end

    def check_true(item, msg)
      return if @errors.present?
      @errors.push(msg) if item != true
    end

    def check_errors(item, name='item')
      return if @errors.present?
      if item.present?
        @errors.concat(item.errors.full_messages)
      else
        @errors.push("Nil item: #{name}")
      end
    end

    def check_current_user
      return if @errors.present?
      check_errors(current_user, 'No current user')
    end

    def set_response type, data
      return if @errors.present?
      @response = {type: type, data: data}
    end

    def current_user
      if token['type'] === 'user'
        @current_user ||= UserModel.where(token['data']).first
      else
        nil
      end
    end
  end
end
