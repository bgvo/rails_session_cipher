# frozen_string_literal: true

require_relative "lib/rails_session_cipher/version"

Gem::Specification.new do |spec|
  spec.name = "rails_session_cipher"
  spec.version = RailsSessionCipher::VERSION
  spec.authors = ["Borja GVO"]
  spec.email = ["borjavinuessa@gmail.com"]

  spec.summary = "Decrypts Rails session cookies."
  spec.description = "Decrypts Rails session cookies."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata["source_code_uri"] = "https://github.com/jukeboxhealth/rails_session_cipher"
  spec.metadata["changelog_uri"] = "https://github.com/jukeboxhealth/rails_session_cipher/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "base64", "0.1.1"
  spec.add_development_dependency "byebug", "~> 11.0"
  spec.add_development_dependency "pry", "~> 0.13.1"
  spec.add_development_dependency "rails", "~>7.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
