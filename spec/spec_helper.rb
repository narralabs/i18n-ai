# frozen_string_literal: true

require "i18n/ai"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    ENV["ANTHROPIC_API_KEY"] = "test_anthropic_api_key"
    ENV["OPENAI_ACCESS_TOKEN"] = "test_openai_access_token"
  end
end
