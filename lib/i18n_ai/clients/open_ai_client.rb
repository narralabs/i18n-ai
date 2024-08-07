# frozen_string_literal: true

require "openai"
require_relative "base_client"

module I18nAi
  module Clients
    # The AnthropicClient class is responsible for interacting with the OpenAI API
    class OpenAiClient < BaseClient
      def initialize
        super
        @client = OpenAI::Client.new(
          access_token: @config[:access_token],
          log_errors: true
        )
      end

      def chat(locale, text)
        response = @client.chat(
          parameters: {
            model: @config[:model],
            messages: [{ role: "user", content: chat_prompt(locale, text) }],
            max_tokens: 5000
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
        response.dig("choices", 0, "message", "content")
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
