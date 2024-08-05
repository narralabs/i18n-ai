# frozen_string_literal: true

RSpec.describe I18nAi::Clients::BaseClient do
  describe "#content" do
    it "generates the correct content string" do
      base_client = I18nAi::Clients::BaseClient.new
      locale = :es
      text = "some text"
      expected_content = "Translate the following YAML content to ES and make sure to retain the keys in english except the first key which is the 2 letter language code:\n\nsome text"
      expect(base_client.content(locale, text)).to eq(expected_content)
    end
  end

  describe "#parse_response" do
    it "raises NotImplementedError" do
      base_client = I18nAi::Clients::BaseClient.new
      expect { base_client.parse_response("some response") }.to raise_error(NotImplementedError)
    end
  end
end
