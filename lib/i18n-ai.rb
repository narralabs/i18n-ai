# frozen_string_literal: true

require_relative "i18n-ai/version"
require_relative "i18n-ai/railtie"
require_relative "i18n-ai/configuration"

module I18nAi
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
