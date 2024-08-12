# frozen_string_literal: true

RSpec.describe I18nAi::Clients::OpenAiClient do
  before do
    I18nAi.configure do |config|
      config.ai_settings = {
        provider: "openai",
        model: "gpt-4o-mini",
        access_token: ENV.fetch("OPENAI_ACCESS_TOKEN", "ABC123")
      }
    end
  end

  let :es_yaml do
    <<~YAML.chomp
      es:
        good_morning: "Buenos Días"
    YAML
  end

  describe "#translate_content" do
    it "returns the translated content" do
      VCR.use_cassette("openai_success") do
        content = file_fixture("en.yml").read
        client = I18nAi::Clients::OpenAiClient.new
        expect(client.translate_content(:es, content)).to eq(es_yaml)
      end
    end
  end
end
