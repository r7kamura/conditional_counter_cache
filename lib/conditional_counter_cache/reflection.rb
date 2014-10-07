module ConditionalCounterCache
  module Reflection
    # @note Overridden
    def counter_cache_column
      Option.new(self).column_name
    end

    # @return [true, false]
    def has_countable?(record)
      Option.new(self).condition.call(record)
    end

    # Utility wrapper of `option[:counter_cache][:condition]`.
    class Condition
      # @param [Proc, String, Symbol, nil]
      def initialize(value)
        @value = value
      end

      def call(record)
        case @value
        when Proc
          record.instance_exec(&@value)
        when nil
          true
        else
          record.send(@value)
        end
      end
    end

    # Utility wrapper of reflection to process `option[:counter_cache]`.
    class Option
      # @param [ActiveRecord::Reflection]
      def initialize(reflection)
        @reflection = reflection
      end

      # @return [String, nil] Specified column name, or nil meaning "use default column name".
      def column_name
        case cache
        when Hash
          cache[:column_name]
        when String, Symbol
          cache.to_s
        when true
          "#{@reflection.active_record.name.demodulize.underscore.pluralize}_count"
        else
          nil
        end
      end

      # @return [Condition]
      def condition
        Condition.new(raw_condition)
      end

      private

      def cache
        @reflection.options[:counter_cache]
      end

      # @return [Proc, String, Symbol, nil]
      def raw_condition
        cache[:condition] if cache.is_a?(Hash)
      end
    end
  end
end
