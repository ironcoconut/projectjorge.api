class UserInteractor
  attr_reader :response, :token, :body, :errors
  def initialize(opts)
    @token = opts[:token]
    @body = opts[:body]
    @errors = []
  end
  def success?
    response.present? && errors.empty?
  end
  def login
    validate(:login, body)
    preload do |data|
      data['user'] = UserModel.login(@validator.data)
    end
    authorize(:login)
    act do
      user = @preload['user']
      set_response(:user, UserPresenter.new(user).user_token)
    end
    return self
  end
  def register
    validate(:register, body)
    preload do |data|
      data['user'] = UserModel.create(@validator.data)
    end
    authorize(:register)
    act do
      user = @preload['user']
      MessagesService.register(user)
      set_response(:user, UserPresenter.new(user).user_token)
    end
    return self
  end
  def find
    validate(:find, body)
    preload do |data|
      data['user'] = UserModel.where(@validator.data).first
      data['relation'] = UserRelationModel.related(data['current_user'], data['user'])
    end
    authorize(:find)
    act do
      set_response(:user, UserPresenter.new(@preload['user']).user)
    end
    return self
  end
  def update
    validate(:update, body)
    preload
    authorize(:update)
    act do
      user = @preload['current_user']
      user.update(@validator.data)
      if user.errors.present?
        @errors = user.errors.full_messages
      else
        set_response(:user, UserPresenter.new(user).user)
      end
    end
    return self
  end
  def friend
    validate(:friend, body)
    preload do |data|
      data['user'] = UserModel.find_or_create_by(@validator.data)
    end
    authorize(:friend)
    act do
      user = @preload['user']
      current_user = @preload['current_user']
      data = {castor_id: current_user.id, pollux_id: user.id}
      UserRelationModel.create(data)
      MessagesService.friend(data)
      set_response(:friend, UserPresenter.new(user).friend)
    end
    return self
  end
  def block
    validate(:block, body)
    preload do |data|
      data['user'] = UserModel.find_or_create_by(@validator.data)
    end
    authorize(:block)
    act do
      user = @preload['user']
      current_user = @preload['current_user']
      UserRelationModel.find_or_create_by(castor_id: current_user.user_id, pollux_id: user.user_id, blocked: true)
      set_response(:block, UserPresenter.new(user).block)
    end
    return self
  end

  private

  def validate(action, data)
    return if !@errors.empty?
    @validator = UserValidator.new(data).send(action)
    @errors = @validator.errors
  end
  def preload
    return if !@errors.empty?
    @preload = {}
    if !token.nil?
      @preload['current_user'] = UserModel.where(token['data']).first
    end
    yield(@preload) if block_given?
  end
  def authorize(action)
    return if !@errors.empty?
    @policy = UserPolicy.new(token, @preload).send(action)
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
