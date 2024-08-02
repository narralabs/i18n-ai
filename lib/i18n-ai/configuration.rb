# frozen_string_literal: true

module I18nAi
  class Configuration
    attr_accessor :generate_locales, :source_locale, :openai_api_key

    def initialize
      @generate_locales = [:es]
      @source_locale = :en
      @openai_api_key = ENV["OPENAI_API_KEY"].presence
    end
  end
end
