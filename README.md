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
belongs_to :tag, counter_cache: { condition: -> :your_favorite_method_name }
belongs_to :tag, counter_cache: { column_name: "items_count" }
belongs_to :tag, counter_cache: { column_name: "items_count", condition: -> { !tagging.item.private? } }
```

## See also
* [Active Record Associations — Ruby on Rails Guides](http://guides.rubyonrails.org/association_basics.html)
* [#23 Counter Cache Column - RailsCasts](http://railscasts.com/episodes/23-counter-cache-column)
* [magnusvk/counter_culture](https://github.com/magnusvk/counter_culture)
* [Counterculture - Wikipedia, the free encyclopedia](http://en.wikipedia.org/wiki/Counterculture)
