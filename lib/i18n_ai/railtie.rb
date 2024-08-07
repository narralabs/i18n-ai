# frozen_string_literal: true

require "rails/railtie"
require "digest"

require_relative "clients/open_ai_client"
require_relative "clients/anthropic_client"

module I18nAi
  # The Railtie class provides a way to integrate I18nAi into an application
  class Railtie < Rails::Railtie
    # Initialize the I18nAi middleware
    class I18nAiMiddleware
      attr_reader :client

      def initialize(app)
        @app = app
        @client = configure_client
        @last_checksum = nil
      end

      def call(env)
        locales_file = locate_locales_file

        if file_exists?(locales_file)
          process_locales_file(locales_file)
        else
          log_file_not_found
        end

        @app.call(env)
      end

      private

      def locate_locales_file
        Rails.root.join("config", "locales", "en.yml")
      end

      def file_exists?(file)
        File.exist?(file)
      end

      def process_locales_file(file)
        current_checksum = calculate_checksum(file)
        log_checksum(current_checksum)

        first_load = @last_checksum.nil?
        file_changed = current_checksum != @last_checksum
        log_generate_status(first_load, file_changed)

        return unless first_load || file_changed

        @last_checksum = current_checksum
        generate_translations(file)
      end

      def log_checksum(checksum)
        puts "==> en.yml checksum: #{checksum}"
      end

      def log_generate_status(first_load, file_changed)
        puts "==> en.yml generate: #{first_load || file_changed}"
      end

      def log_file_not_found
        puts "en.yml file not found"
      end

      def configure_client
        config = I18nAi.configuration.ai_settings
        case config[:provider]
        when "anthropic"
          I18nAi::Clients::AnthropicClient.new
        when "openai"
          I18nAi::Clients::OpenAiClient.new
        else
          raise "Unknown AI provider: #{config[:provider]}"
        end
      end

      def generate_translations(locales_file)
        locales = load_locales(locales_file)
        text_to_translate = locales.to_yaml
        generate_locales = I18nAi.configuration.generate_locales

        generate_locales.each do |locale|
          translated_content = client.translate_content(locale, text_to_translate)
          save_translated_locales(locale, translated_content) if translated_content
        end
      end

      def load_locales(locales_file)
        YAML.load_file(locales_file)
      end

      def save_translated_locales(locale, translated_content)
        locales_file = Rails.root.join("config", "locales", "#{locale}.yml")
        File.write(locales_file, translated_content)
      end

      def calculate_checksum(file_path)
        Digest::SHA256.file(file_path).hexdigest
      end
    end

    initializer "i18n_ai.configure_middleware", before: :build_middleware_stack do |app|
      app.middleware.use I18nAiMiddleware
    end
  end
end
