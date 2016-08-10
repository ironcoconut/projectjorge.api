class Presenter
  def initialize data
    @data = data
  end

  private

  def build_hash *items
    mapped = items.map do |i| 
      item = @data.send(i)
      if !item.nil?
        [i, item]
      else
        nil
      end
    end
    return mapped.compact.to_h
  end
end

class UserPresenter < Presenter
  def user_token
    build_hash('user_id', 'handle')
  end
  def user
    build_hash('handle', 'email', 'phone', 'avatar', 'prefer_email', 'prefer_phone', 'contact_frequency')
  end
  def friend
    build_hash('handle')
  end
  def block
    build_hash('handle')
  end
end

class EventTemplatePresenter < Presenter
  def event_template
    build_hash('name')
  end
end
