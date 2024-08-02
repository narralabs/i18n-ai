# frozen_string_literal: true

require "rails/railtie"
require "openai"
require "digest"
require_relative "middleware"

module I18nAi
  class Railtie < Rails::Railtie
    initializer "i18n_ai.configure_middleware", before: :build_middleware_stack do |app|
      app.middleware.use I18nAi::Middleware
    end
  end
end
