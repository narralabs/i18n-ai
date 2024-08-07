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

      def chat_prompt(locale, text_to_translate)
        <<~PROMPT
          Translate the following YAML content to the language of the country using the ISO 639 language code
          of #{locale}. Make sure to retain the keys in english except the first key which is the 2 letter language code:

          """"
          #{text_to_translate}"
          """"

          Return only the YAML content without explanation.

          Example:

            {{two_letter_locale_abbrev}}:
              key_1: "value1"
        PROMPT
      end

      def chat(locale, text)
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
