# frozen_string_literal: true

require "anthropic"
require_relative "base_client"

module I18nAi
  module Clients
    class AnthropicClient < BaseClient
      def initialize
        super()
        @client = Anthropic::Client.new(
          access_token: @config[:access_token]
        )
      end

      def chat(locale, text)
        response = @client.messages(
          parameters: {
            model: @config[:model],
            messages: [
              { role: "user", content: content(locale, text) }
            ]
          }
        )

        parse_response(response)
      rescue StandardError => e
        handle_error(e)
      end

      private

      def parse_response(response)
        response.dig("content", 0, "text")
      rescue TypeError, NoMethodError => e
        handle_error(e)
      end

      def handle_error(error)
        puts "Error: #{error.message}"
        nil
      end
    end
  end
end
