module Mutator
  class Base
    include ActiveModel::Validations
    include Normalizr::Concern
    include Virtus.model

    class << self
      attr_reader :check_all, :check_some

      def attribute(name, type=String, options={})
        attr_reader name

        define_method("#{name}=") do |raw_value|
          @coercions ||= {}

          virtus = Virtus::Attribute.build(type, options)
          value = virtus.coerce(raw_value)
          coerced = virtus.value_coerced?(value)

          if coerced
            instance_variable_set("@#{name}", value)
          else
            @coercions[name.to_sym] = "unable to coerce"
          end
        end

        super(name, type, options)
      end

      def set_check_all *items
        @check_all ||= []
        @check_all.concat(items)
      end

      def set_check_some *items
        @check_some ||= []
        @check_some.push(items)
      end
    end

    validate :process_all_errors, :process_some_errors

    def initialize(params={})
      super(params)
      yield(self) if block_given?
    end

    def process_all_errors
      all = self.class.check_all || []
      all.each { |name| process_name(name) }
    end

    def process_name(name)
      @coercions ||= {}
      if send(name) === nil
        message = @coercions[name] || "must be present"
        errors.add(name, message)
      end
    end

    def process_some_errors
      some = self.class.check_some || []
      some.each { |group| process_group(group) }
    end

    def process_group(group)
      # false is a valid value
      at_least_one_present = group.any? { |names| !send(names).nil? }

      if !at_least_one_present
        errors.add(:base, "at least one must be present: #{group.join(', ')}")
      end
    end

    def attributes
      super.select { |key, value| !value.nil? }
    end
  end
end
