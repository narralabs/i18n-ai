# frozen_string_literal: true

require "anthropic"
require_relative "../../lib/i18n-ai/clients/anthropic_client"

RSpec.describe I18nAi::Clients::AnthropicClient do
  let(:anthropic_client) { I18nAi::Clients::AnthropicClient.new }

  describe "#chat" do
    it "calls the Anthropic API and parses the response" do
      locale = :es
      text = "some text"
      response = { "content" => [{ "text" => "translated text" }] }

      allow_any_instance_of(Anthropic::Client).to receive(:messages).and_return(response)

      expect(anthropic_client.chat(locale, text)).to eq("translated text")
    end
  end
end
