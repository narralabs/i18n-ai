require "openai"
require_relative "base_client"

module I18nAi
  module Clients
    class OpenAi < BaseClient
      def initialize
        @client = OpenAI::Client.new(
          access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"),
          log_errors: true
        )
      end

      def chat(locale, text)
        response = @client.chat(
          parameters: {
            model: "gpt-4o-mini",
            messages: [{ role: "user", content: content(locale, text) }],
            max_tokens: 5000
          }
        )

        parse_response(response)
      end

      private

      def parse_response(response)
        response.dig("choices", 0, "message", "content")
      end
    end
  end
end
