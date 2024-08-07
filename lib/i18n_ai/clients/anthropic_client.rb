# frozen_string_literal: true

require "anthropic"
require_relative "base_client"

module I18nAi
  module Clients
    # The AnthropicClient class is responsible for interacting with the Anthropic API
    class AnthropicClient < BaseClient
      attr_reader :client

      def initialize
        super
        @client = Anthropic::Client.new(access_token: config[:access_token])
      end

      def chat(locale, text)
        response = client.messages(
          parameters: {
            model: config[:model],
            messages: [{ role: "user", content: chat_prompt(locale, text) }],
            max_tokens: 1024
          }
        )
        parse_response(response)
      end

      private

      def chat_prompt(locale, text_to_translate)
        <<~PROMPT
          Translate the following YAML content to the language of the country using the ISO 639 language code
          of #{locale}. Make sure to retain the keys in english except the first key which is the 2 letter language code:

          """"
          #{text_to_translate}"
          """"

          Return only YAML content without explanation.

          Example:

            {{two_letter_locale_abbrev}}:
              key_1: "value1"
        PROMPT
      end

      def parse_response(response)
        response.dig("content", 0, "text")
      end

      def extract_translated_content(chat_content)
        chat_content
      end
    end
  end
end
