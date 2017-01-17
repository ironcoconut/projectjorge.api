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
      rescue CheckFailedError
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
      check_present(:current_user)
    end

    def set_response type, data
      @response = {type: type, data: data}
    end

    def current_user
      return @current_user if @current_user.present?

      if token.present? && token['type'] === 'user'
        @current_user ||= CompositeUser.new(token['data'])
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
        raise CheckFailedError.new
      end
    end

    def raise_error?
      raise CheckFailedError.new if @errors.present?
    end

    # This is a composite class. It should live elsewhere.
    class CompositeUser

      attr_reader :token, :model, :graph

      delegate :id, :to => :model
      delegate :friend_ids, :neighbor_ids, :relation_ids, :blocked_ids, :to => :graph

      def initialize(token)
        @token = token
        @model = Model::User.where(token).first
        @graph = Graph::User.new(token)
      end

      def upcoming_events
        @events ||= Model::Event.
          joins("INNER JOIN rsvps on rsvps.event_id = events.id").
          where("rsvps.declined IS NOT TRUE").
          where("rsvps.accepted IS TRUE").
          where("rsvps.pollux_id = ?", id).
          where("events.ends_at > ?", Time.now).
          select("events.*, rsvps.admin").
          distinct
      end

      def invitations
        @invitations ||= Model::Event.
          joins("INNER JOIN rsvps on rsvps.event_id = events.id").
          where("rsvps.declined IS NOT TRUE").
          where("rsvps.accepted IS NOT TRUE").
          where("rsvps.pollux_id = ?", id).
          where("events.ends_at > ?", Time.now).
          select("events.*, rsvps.admin").
          distinct
      end
    end
  end
end
