# frozen_string_literal: true

require "openai"
require_relative "base_client"

module I18nAi
  module Clients
    class OpenAiClient < BaseClient
      def initialize(config)
        super()
        @config = config
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
        # Log the error or handle it as needed
        puts "Error: #{error.message}"
        nil
      end
    end
  end
end
