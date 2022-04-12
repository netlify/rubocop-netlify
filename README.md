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
All cops are located under [lib/rubocop/cop/netlify](lib/rubocop/cop/netlify), and contain examples/documentation.

## Release

1. Make sure you have an account in https://rubygems.org/ and be a part of https://rubygems.org/gems/rubocop-netlify owners
2. Update a version in [lib/rubocop/netlify/version.rb](lib/rubocop/netlify/version.rb)
3. Tag it (also maybe make a new release in GitHub)
4. Run `gem build rubocop-netlify.gemspec` to build a gem
5. Run `gem push` with a newly created gem file
6. Done done!
