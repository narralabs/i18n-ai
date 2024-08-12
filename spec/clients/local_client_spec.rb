# frozen_string_literal: true

RSpec.describe I18nAi::Clients::LocalClient do
  let :es_yaml do
    <<~YAML.chomp
      es:
        good_morning: "Buenos Días"
    YAML
  end

  before do
    I18nAi.configure do |config|
      config.ai_settings = {
        provider: "local",
        model: "mistral",
        url: "http://localhost:11434/api/generate"
      }
    end
  end

  describe "#translate_content" do
    it "returns the translated content" do
      VCR.use_cassette("local_success") do
        content = file_fixture("en.yml").read
        client = I18nAi::Clients::LocalClient.new
        expect(client.translate_content(:es, content)).to eq(es_yaml)
      end
    end
  end
end
