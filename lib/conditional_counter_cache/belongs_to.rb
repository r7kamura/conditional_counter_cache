module ConditionalCounterCache
  # Overrides ActiveRecord 4.1.4's counter cache implementation.
  module BelongsTo
    def add_counter_cache_methods(mixin)
      return if mixin.method_defined? :belongs_to_counter_cache_after_create

      mixin.class_eval do
        def belongs_to_counter_cache_after_create(reflection)
          if record = send(reflection.name)
            return unless reflection.has_countable?(self)
            cache_column = reflection.counter_cache_column
            record.class.increment_counter(cache_column, record.id)
            @_after_create_counter_called = true
          end
        end

        def belongs_to_counter_cache_before_destroy(reflection)
          foreign_key = reflection.foreign_key.to_sym
          unless destroyed_by_association && destroyed_by_association.foreign_key.to_sym == foreign_key
            record = send reflection.name
            if record && !self.destroyed?
              return unless reflection.has_countable?(self)
              cache_column = reflection.counter_cache_column
              record.class.decrement_counter(cache_column, record.id)
            end
          end
        end

        def belongs_to_counter_cache_after_update(reflection)
          foreign_key  = reflection.foreign_key
          cache_column = reflection.counter_cache_column

          if (@_after_create_counter_called ||= false)
            @_after_create_counter_called = false
          elsif attribute_changed?(foreign_key) && !new_record? && reflection.constructable?
            return unless reflection.has_countable?(self)
            model           = reflection.klass
            foreign_key_was = attribute_was foreign_key
            foreign_key     = attribute foreign_key

            if foreign_key && model.respond_to?(:increment_counter)
              model.increment_counter(cache_column, foreign_key)
            end
            if foreign_key_was && model.respond_to?(:decrement_counter)
              model.decrement_counter(cache_column, foreign_key_was)
            end
          end
        end
      end
    end
  end
end
