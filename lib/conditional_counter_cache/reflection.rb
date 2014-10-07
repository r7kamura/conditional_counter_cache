module ConditionalCounterCache
  module Reflection
    # @note Overridden
    def counter_cache_column
      Option.new(options[:counter_cache]).column_name ||
        "#{active_record.name.demodulize.underscore.pluralize}_count"
    end

    # @return [true, false]
    def has_countable?(record)
      Option.new(options[:counter_cache]).condition.call(record)
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

    # Utility wrapper of `option[:counter_cache]`.
    class Option
      # @param [Hash, String, true, nil]
      def initialize(value)
        @value = value
      end

      # @return [String, nil] Specified column name, or nil meaning "use default column name".
      def column_name
        case
        when has_hash_value?
          @value[:column_name]
        when has_true_value?
          nil
        else
          @value.to_s
        end
      end

      # @return [Condition]
      def condition
        Condition.new(raw_condition)
      end

      private

      def has_hash_value?
        @value.is_a?(Hash)
      end

      def has_true_value?
        @value == true
      end

      # @return [Proc, String, Symbol, nil]
      def raw_condition
        @value[:condition] if has_hash_value?
      end
    end
  end
end
