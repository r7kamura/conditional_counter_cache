# ConditionalCounterCache
Allows you to customize condition of counter cache.

## Usage
Customize condition via `:counter_cache` option:

```ruby
class Tagging < ActiveRecord::Base
  belongs_to :item
  belongs_to :tag, counter_cache: { condition: -> { !tagging.item.private? } }
end
```

Other examples:

```ruby
belongs_to :tag, counter_cache: true
belongs_to :tag, counter_cache: "items_count"
belongs_to :tag, counter_cache: { condition: -> { !tagging.item.private? } }
belongs_to :tag, counter_cache: { column_name: "items_count" }
belongs_to :tag, counter_cache: { column_name: "items_count", condition: -> { !tagging.item.private? } }
```
