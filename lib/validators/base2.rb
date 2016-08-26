module Validator
  class Base2
    include Normalizr::Concern
    include Virtus.model

    attr_reader :errors

    class << self
      attr_reader :check_all, :check_some

      def attribute(name, type=String, options={})
        attr_reader name

        define_method("#{name}=") do |raw_value|
          virtus = Virtus::Attribute.build(type, options)
          value = virtus.coerce(raw_value)
          coerced = virtus.value_coerced?(value)

          if coerced
            instance_variable_set("@#{name}", value)
          else
            @errors.push("Unable to coerce: #{name}")
          end
        end
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

    def initialize *args
      @errors = []
      super
      process_all_errors
      process_some_errors
    end

    def process_all_errors
      all = self.class.check_all

      missing_all = all.map { |i| send(i) === nil ? i : nil }.compact

      if (missing_all.present?)
        @errors.push("Must be present: #{missing_all.join(', ')}")
      end
    end

    def process_some_errors
      some = self.class.check_some

      some.each do |group|
        at_least_one_present = group.any? { |i| !send(i).nil? }

        if !at_least_one_present
          @errors.push("None present: #{group.join(', ')}")
        end
      end
    end
  end
end
