# frozen_string_literal: true

require_relative "../../lib/i18n-ai/clients/open_ai_client"

RSpec.describe I18nAi::Clients::OpenAiClient do
  let(:open_ai_client) { I18nAi::Clients::OpenAiClient.new }

  describe "#chat" do
    it "calls the OpenAI API and parses the response" do
      locale = :es
      text = "some text"
      response = { "choices" => [{ "message" => { "content" => "translated text" } }] }

      allow_any_instance_of(OpenAI::Client).to receive(:chat).and_return(response)

      expect(open_ai_client.chat(locale, text)).to eq("translated text")
    end
  end
end
