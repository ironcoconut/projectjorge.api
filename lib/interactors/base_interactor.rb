module Interactor
  class Base
    attr_reader :response, :errors, :token, :body, :params

    def main
      raise "Please include a main function in #{self.class.name}"
    end

    def success?
      errors.empty? && response.present?
    end

    private

    def initialize(opts)
      @token = opts[:token]
      @body = opts[:body]
      @params = opts[:params]
      @errors = {}

      begin
        main()
      rescue Interactor::MainError
        # errors already recorded
      end
    end

    # don't error after extract b/c there might be >1 mutator
    def extract mutator
      mutator.validate
      add_error(mutator.class.name, mutator.errors.to_h)
      mutator.attributes
    end

    def extract_id mutator
      extract(mutator)[:id]
    end

    # gather up the extractions and check for errors once done
    def check_extraction
      yield
      raise_error?
    end

    def check_present(symbol)
      item = send(symbol)
      raise_error(symbol, "is nil") if item.nil?
    end

    def check_true(symbol)
      item = send(symbol)
      raise_error(symbol, "not true") if item != true
    end

    def check_errors(symbol)
      item = send(symbol)
      if item.present?
        raise_error(symbol, item.errors.full_messages) if item.invalid?
      else
        raise_error(symbol, "is nil")
      end
    end

    def check_current_user
      check_errors(:current_user)
    end

    def set_response type, data
      @response = {type: type, data: data}
    end

    def current_user
      if token.present? && token['type'] === 'user'
        @current_user ||= Model::User.where(token['data']).first
      else
        nil
      end
    end

    def add_error(name, msgs={})
      if msgs.present?
        @errors[name] = msgs
      end
    end

    def raise_error(name, msgs={})
      if msgs.present?
        @errors[name] = msgs
        raise MainError.new
      end
    end

    def raise_error?
      raise MainError.new if @errors.present?
    end
  end
end
