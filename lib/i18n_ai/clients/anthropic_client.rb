# frozen_string_literal: true

require "anthropic"
require_relative "base_client"

module I18nAi
  module Clients
    # The AnthropicClient class is responsible for interacting with the Anthropic API
    class AnthropicClient < BaseClient
      def initialize
        super
        @client = Anthropic::Client.new(
          access_token: config[:access_token]
        )
      end

      def chat(locale, text)
        response = @client.messages(
          parameters: {
            model: config[:model],
            messages: [{ role: "user", content: chat_prompt(locale, text) }],
            max_tokens: config[:max_tokens] || 4096
          }
        )
        parse_response(response)
      end

      private

      def parse_response(response)
        response.dig("content", 0, "text")
      end

      def extract_translated_content(chat_content)
        chat_content
      end
    end
  end
end
