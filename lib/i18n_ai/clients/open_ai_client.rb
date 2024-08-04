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
            messages: [{ role: "user", content: content(locale, text) }],
            max_tokens: 5000
          }
        )

        parse_response(response)
      rescue StandardError => e
        handle_error(e)
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
    end
  end
end
