# frozen_string_literal: true

require_relative "i18n_ai/version"
require_relative "i18n_ai/railtie"
require_relative "i18n_ai/configuration"

# The I18nAi module provides functionality for integrating AI-based translation services
module I18nAi
  class Error < StandardError; end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
