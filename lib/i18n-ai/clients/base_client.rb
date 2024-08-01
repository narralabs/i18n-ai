# frozen_string_literal: true

module I18nAi
  module Clients
    class BaseClient
      def content(locale, text_to_translate)
        "Translate the following YAML content to #{locale.to_s.upcase} and make sure to retain the keys in english except the first key which is the 2 letter language code:\n\n#{text_to_translate}"
      end

      def parse_response(response)
        raise NotImplementedError, "Subclasses must implement this method"
      end
    end
  end
end
