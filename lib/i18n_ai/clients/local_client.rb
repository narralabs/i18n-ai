# frozen_string_literal: true

require 'uri'
require 'net/http'

require_relative "base_client"

module I18nAi
  module Clients
    class LocalClient < BaseClient
      def initialize
        super
      end

      def chat(locale, text)
        uri = URI.parse(@config[:url])
        request = Net::HTTP::Post.new(uri)
        request.content_type = 'application/json'

        data = {
          "model": @config[:model],
          "prompt": 
            "Translate the following YAML content to the language with the abbreviation of #{locale.to_s.upcase} and make sure to retain the keys in english except the first key which is the 2 letter language code:\n\n#{text}. Return only YAML content without explanation. Example: {{two letter locale abbrev.}}: key_1: value1",
          "stream": false
        }
        request.body = data.to_json

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(request)
        end
        
        parse_response(JSON.parse(response.body))
      rescue StandardError => e
        handle_error(e)
      end

      private

      def extract_translated_content(response)
        response
      end

      def parse_response(response)
        response.dig("response")
      rescue TypeError, NoMethodError => e
        handle_error(e)
      end

      def handle_error(error)
        puts "Error: #{error.message}"
      end
    end
  end
end
