require_relative "i18n-ai/version"
require_relative "i18n-ai/railtie"
require_relative "i18n-ai/configuration"

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
