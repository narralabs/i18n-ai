# frozen_string_literal: true

require "dotenv/load"
require "active_support/all"
require_relative "../lib/i18n-ai"

# Require all files from ./support
Dir[File.join(__dir__, "support", "**", "*.rb")].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Allow using fit, fdescribe, focontext, and the :focus flag
  config.filter_run_when_matching :focus
end
