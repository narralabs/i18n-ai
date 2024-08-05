# frozen_string_literal: true

require_relative "lib/i18n_ai/version"

Gem::Specification.new do |spec|
  spec.name = "i18n-ai"
  spec.version = I18nAi::VERSION
  spec.authors = ["William Estoque"]
  spec.email = ["william.estoque@gmail.com"]

  spec.summary = "i18n-ai is a gem that converts your locales into different languages automatically"
  spec.homepage = "https://github.com/narralabs/i18n-ai"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/narralabs/i18n-ai"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_runtime_dependency("railties", ">= 6.0.0", "< 8")
  spec.add_dependency "anthropic"
  spec.add_dependency "ruby-openai"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
