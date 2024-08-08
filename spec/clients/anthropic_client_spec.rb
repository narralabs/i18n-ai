# frozen_string_literal: true

RSpec.describe I18nAi::Clients::AnthropicClient do
  describe "#translate_content" do
    describe "without max_tokens parameter" do
      before do
        I18nAi.configure do |config|
          config.ai_settings = {
            provider: "anthropic",
            model: "claude-3-haiku-20240307",
            access_token: ENV.fetch("ANTHROPIC_ACCESS_TOKEN", "ABC123")
          }
        end
      end

      it "sets the max_tokens parameter of Anthropic client to 4096" do
        VCR.use_cassette("anthropic_success") do
          content = file_fixture("en.yml").read
          client = I18nAi::Clients::AnthropicClient.new

          allow_any_instance_of(Anthropic::Client).to receive(:messages).with(
            {
              parameters: {
                model: "claude-3-haiku-20240307",
                messages: [{
                  role: "user",
                  content: client.send(:chat_prompt, :es, content)
                }],
                max_tokens: 4096
              }
            }
          ).and_call_original

          client.translate_content(:es, content)
        end
      end
    end

    describe "with max_tokens parameter" do
      before do
        I18nAi.configure do |config|
          config.ai_settings = {
            provider: "anthropic",
            model: "claude-3-haiku-20240307",
            access_token: ENV.fetch("ANTHROPIC_ACCESS_TOKEN", "ABC123"),
            max_tokens: 1000
          }
        end
      end

      it "sets the max_tokens parameter of Anthropic client to specified value" do
        VCR.use_cassette("anthropic_max_token_success") do
          content = file_fixture("en.yml").read
          client = I18nAi::Clients::AnthropicClient.new

          allow_any_instance_of(Anthropic::Client).to receive(:messages).with(
            {
              parameters: {
                model: "claude-3-haiku-20240307",
                messages: [{
                  role: "user",
                  content: client.send(:chat_prompt, :es, content)
                }],
                max_tokens: 1000
              }
            }
          ).and_call_original

          client.translate_content(:es, content)
        end
      end
    end
  end
end
