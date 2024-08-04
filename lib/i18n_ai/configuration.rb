# frozen_string_literal: true

module I18nAi
  # Configuration class for I18nAi
  class Configuration
    attr_accessor :ai_settings, :generate_locales

    def initialize
      @ai_settings = {}
      @generate_locales = [:es]
    end
  end
end
