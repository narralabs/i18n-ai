# frozen_string_literal: true

module I18nAi
  class Configuration
    attr_accessor :generate_locales

    def initialize
      @generate_locales = [:es]
    end
  end
end
