# frozen_string_literal: true

require "i18n_ai"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<ACCESS_TOKEN>") do
    I18nAi.configuration.ai_settings[:access_token]
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.add_setting :file_fixture_path, default: "spec/fixtures/files"

  config.include(Module.new do
    def file_fixture(file_name)
      path = RSpec.configuration.file_fixture_path
      file_path = File.join(path, file_name)
      unless File.exist?(file_path)
        raise ArgumentError,
              "the directory '#{path}' does not contain a file named '#{file_name}'"
      end

      File.new(file_path)
    end
  end)

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
