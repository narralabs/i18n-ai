# frozen_string_literal: true

RSpec.describe I18nAi::Clients::BaseClient do
  describe "#translate_content" do
    it "raises NotImplementedError" do
      base_client = I18nAi::Clients::BaseClient.new
      locale = :es
      locale_file = file_fixture("en.yml")
      content = locale_file.read
      expect {
        base_client.translate_content(locale, content)
      }.to raise_error(NotImplementedError)
    end
  end
end
