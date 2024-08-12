# frozen_string_literal: true

require "uri"
require "net/http"

require_relative "base_client"

module I18nAi
  module Clients
    class LocalClient < BaseClient
      private

      def chat_prompt(source_locale, target_locale, text)
        <<~PROMPT.chomp
          Title: Translate the YAML Text from ISO 639 language code #{source_locale} to #{target_locale}.

          Step 1. Translate the first key (2-letter language code) from #{source_locale} to #{target_locale}, keeping the rest of the keys unchanged.
          Step 2. Translate all the values from #{source_locale} to #{target_locale} locale.

          Text to translate:
          """
          #{text}
          """

          Return only the valid translated YAML with proper formatting with no explanation.
        PROMPT
      end

      def chat(locale, text)
        request = build_request(locale, text)
        response = send_request(request)
        parse_response(response.body)
      rescue StandardError => e
        handle_error(e)
      end

      def build_request(locale, text)
        uri = URI.parse(config[:url])
        request = Net::HTTP::Post.new(uri)
        request.content_type = "application/json"
        request.body = request_body(locale, text).to_json
        request
      end

      def request_body(locale, text)
        {
          "model": config[:model],
          "prompt": chat_prompt("en", locale, text),
          "stream": false
        }
      end

      def send_request(request)
        uri = URI.parse(config[:url])
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
          http.request(request)
        end
      end

      def extract_translated_content(chat_content)
        match_data = chat_content.match(/```(.*?)```/m)
        match_data ? match_data[1].strip : nil
      end

      def parse_response(response)
        puts "*" * 80
        puts response

        json = JSON.parse(response)
        json.dig("response")
      rescue TypeError, NoMethodError => e
        handle_error(e)
      end

      def handle_error(error)
        puts "Error: #{error.message}"
      end
    end
  end
end
