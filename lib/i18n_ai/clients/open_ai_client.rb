# frozen_string_literal: true

require "openai"
require_relative "base_client"

module I18nAi
  module Clients
    class OpenAiClient < BaseClient
      def initialize
        super
        @client = OpenAI::Client.new(
          access_token: config[:access_token],
          log_errors: true
        )
      end

      def chat(locale, text)
        response = @client.chat(
          parameters: {
            model: @config[:model],
            messages: [{ role: "user", content: chat_prompt(locale, text) }],
            max_tokens: config[:max_tokens] || 4096
          }
        )
        parse_response(response)
      end

      private

      def parse_response(response)
        response.dig("choices", 0, "message", "content")
      rescue TypeError, NoMethodError => e
        handle_error(e)
      end

      def handle_error(error)
        puts "Error: #{error.message}"
      end

      def extract_translated_content(chat_content)
        match_data = chat_content.match(/```yaml(.*?)```/m)
        match_data ? match_data[1].strip : nil
      end
    end
  end
end
