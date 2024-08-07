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
          access_token: @config[:access_token]
        )
      end

      def chat(locale, text)
        response = @client.messages(
          parameters: {
            model: @config[:model],
            messages: [{ role: "user", content: chat_prompt(locale, text) }]
          }
        )

        parse_response(response)
      rescue StandardError => e
        handle_error(e)
      end

      private

      def chat_prompt(locale, text_to_translate)
        # rubocop:disable Layout/LineLength
        "Translate the following YAML content to #{locale.to_s.upcase} and make sure to retain the keys in english except the first key which is the 2 letter language code:\n\n#{text_to_translate}"
        # rubocop:enable Layout/LineLength
      end

      def parse_response(response)
        response.dig("content", 0, "text")
      rescue TypeError, NoMethodError => e
        handle_error(e)
      end

      def handle_error(error)
        puts "Error: #{error.message}"
      end

      def extract_translated_content(chat_content)
        match_data = response.match(/```yaml(.*?)```/m)
        match_data ? match_data[1].strip : nil
      end
    end
  end
end
