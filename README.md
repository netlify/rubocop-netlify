# RuboCop::Netlify

This repository provides additional RuboCops Cops for use on Netlify open source and internal Ruby projects.

TODO: Add recommended RuboCop configuration to inherit from

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-netlify'
```

And then this to `.rubocop.yml`

```yml
require:
  - rubocop-netlify
```

## Testing
```
bundle install
bundle exec rake test
```

## The Cops
All cops are located under lib/rubocop/cop/netlify, and contain examples/documentation.

