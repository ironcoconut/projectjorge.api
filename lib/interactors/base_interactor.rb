class BaseInteractor
  attr_reader :response, :token, :body, :errors

  def initialize(opts)
    @token = opts[:token]
    @body = opts[:body]
    @errors = []
  end
  def success?
    response.present? && errors.empty?
  end

  private

  [:base_validator, :current_model, :current_key, :base_policy].each do |n|
    define_method(n) { raise "Please set :#{n}"; }
  end

  def self.set name, value
    define_method(name) { return value; }
  end

  def validate(action, data)
    return if !@errors.empty?
    @validator = base_validator.new(data).send(action)
    @errors = @validator.errors
  end
  def preload
    return if !@errors.empty?
    @preload = {}
    if !token.nil?
      @preload[current_key] = current_model.where(token['data']).first
    end
    yield(@preload) if block_given?
  end
  def authorize(action)
    return if !@errors.empty?
    @policy = base_policy.new(token, @preload).send(action)
    @errors = @policy.errors
  end
  def act
    return if !@errors.empty?
    yield
  end
  def set_response(type, data)
    @response = {type: type, data: data}
  end
end
