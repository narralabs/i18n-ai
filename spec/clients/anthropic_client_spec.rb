# frozen_string_literal: true

module I18nAi
  module Clients
    RSpec.describe AnthropicClient do
      before do
        I18nAi.configure do |config|
          config.ai_settings = {
            provider: "anthropic",
            model: "claude-3-haiku-20240307",
            access_token: ENV.fetch("ANTHROPIC_ACCESS_TOKEN", "ABC123")
          }
        end
      end

      let :es_yaml do
        <<~YAML.chomp
          es:
            good_morning: "Buenos días"
        YAML
      end

      describe "#translate_content" do
        it "returns the translated content" do
          VCR.use_cassette("anthropic_success") do
            content = file_fixture("en.yml").read
            client = I18nAi::Clients::AnthropicClient.new
            expect(client.translate_content(:es, content)).to eq(es_yaml)
          end
        end
      end
    end
  end
end
