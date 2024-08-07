# frozen_string_literal: true

module I18nAi
  module Clients
    # The BaseClient class serves as a base class for all AI client implementations
    class BaseClient
      attr_reader :config

      def initialize
        @config = I18nAi.configuration.ai_settings
      end

      def translate_content(locale, content)
        chat_content = chat(locale, content)
        extract_translated_content(chat_content)
      end

      private

      def chat(locale, text)
        raise NotImplementedError, "Subclasses must implement this method"
      end

      def chat_prompt(locale, text_to_translate)
        raise NotImplementedError, "Subclasses must implement this method"
      end

      def parse_response(response)
        raise NotImplementedError, "Subclasses must implement this method"
      end

      def extract_translated_content(chat_content)
        raise NotImplementedError, "Subclasses must implement this method"
      end
    end
  end
end
