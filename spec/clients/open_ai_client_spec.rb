# frozen_string_literal: true

RSpec.describe I18nAi::Clients::OpenAiClient do
  describe "#translate_content" do
    describe "without max_tokens parameter" do
      before do
        I18nAi.configure do |config|
          config.ai_settings = {
            provider: "openai",
            model: "gpt-4o-mini",
            access_token: ENV.fetch("OPENAI_ACCESS_TOKEN", "ABC123")
          }
        end
      end

      it "sets the max_tokens parameter of OpenAI client to 4096" do
        VCR.use_cassette("openai_success") do
          content = file_fixture("en.yml").read
          client = I18nAi::Clients::OpenAiClient.new

          allow_any_instance_of(OpenAI::Client).to receive(:chat).with({
            parameters: {
              model: "gpt-4o-mini",
              messages: [{
                role: "user",
                content: client.send(:chat_prompt, :es, content)
              }],
              max_tokens: 4096
            }
          }).and_call_original

          client.translate_content(:es, content)
        end
      end
    end

    describe "with max_tokens parameter" do
      before do
        I18nAi.configure do |config|
          config.ai_settings = {
            provider: "openai",
            model: "gpt-4o-mini",
            access_token: ENV.fetch("OPENAI_ACCESS_TOKEN", "ABC123"),
            max_tokens: 1000
          }
        end
      end

      it "sets the max_tokens parameter of OpenAI client to specified value" do
        VCR.use_cassette("openai_max_token_success") do
          content = file_fixture("en.yml").read
          client = I18nAi::Clients::OpenAiClient.new

          allow_any_instance_of(OpenAI::Client).to receive(:chat).with({
            parameters: {
              model: "gpt-4o-mini",
              messages: [{
                role: "user",
                content: client.send(:chat_prompt, :es, content)
              }],
              max_tokens: 1000
            }
          }).and_call_original

          client.translate_content(:es, content)
        end
      end
    end
  end
end
