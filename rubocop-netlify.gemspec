# frozen_string_literal: true

require_relative 'lib/rubocop/netlify/version'

Gem::Specification.new do |spec|
  spec.name          = "rubocop-netlify"
  spec.version       = RuboCop::Netlify::VERSION
  spec.authors       = ["Esteban Pastorino"]
  spec.email         = ["esteban@netlify.com"]

  spec.summary       = "RuboCop Netlify"
  spec.description   = "Code style checking for Netlify Ruby repositories"
  spec.homepage      = "https://github.com/netlify/rubocop-netlify"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.add_dependency "rubocop", "~> 0.87", "< 0.88"
  spec.add_development_dependency "minitest", "~> 5.10"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]
end
