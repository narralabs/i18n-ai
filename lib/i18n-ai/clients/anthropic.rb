require "anthropic"
require_relative "base_client"

module I18nAi
  module Clients
    class Anthropic < BaseClient
      def initialize
        @client = Anthropic::Client.new(
          api_key: ENV.fetch("ANTHROPIC_API_KEY")
        )
      end

      def chat(locale, text)
        response = @client.messages(
          parameters: {
            model: "claude-3-haiku-20240307",
            messages: [
              { "role": "user", "content": content(locale, text) }
            ]
          }
        )

        parse_response(response)
      end

      private

      def parse_response(response)
        response.dig("content", 0, "text")
      end
    end
  end
end
