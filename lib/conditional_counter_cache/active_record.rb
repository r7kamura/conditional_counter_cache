ActiveSupport.on_load(:active_record) do
  ActiveRecord::Reflection::AssociationReflection.prepend(ConditionalCounterCache::Reflection)
  ActiveRecord::Associations::Builder::BelongsTo.singleton_class.prepend(ConditionalCounterCache::BelongsTo)
end
