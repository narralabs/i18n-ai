# frozen_string_literal: true

require "anthropic"
require_relative "base_client"

module I18nAi
  module Clients
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
