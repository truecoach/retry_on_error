require_relative 'lib/retry_on_error/version'

Gem::Specification.new do |spec|
  spec.name          = "retry_on_error"
  spec.version       = RetryOnError::VERSION
  spec.authors       = ["Adam Steel"]
  spec.email         = ["adamgsteel@gmail.com"]

  spec.summary       = %q{Easily customize retry behavior for an operation}
  spec.description   = %q{Especially useful for handling cross network calls.}
  spec.homepage      = "https://github.com/truecoach/retry_on_error"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'rubocop'
end