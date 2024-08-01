require "rails/railtie"
require "openai"
require "digest"

module I18nAi
  class Railtie < Rails::Railtie
    class I18nAiMiddleware
      def initialize(app)
        @app = app
        @client = OpenAI::Client.new(
          access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"),
          log_errors: true
        )
        @last_checksum = nil
      end

      def call(env)
        locales_file = Rails.root.join("config", "locales", "en.yml")

        if File.exist?(locales_file)
          current_checksum = calculate_checksum(locales_file)
          puts "==> en.yml checksum: #{current_checksum}"
          first_load = @last_checksum.nil?
          file_changed = current_checksum != @last_checksum
          puts "==> en.yml generate: #{first_load || file_changed}"

          if first_load || file_changed
            @last_checksum = current_checksum
            generate_translations(locales_file)
          end
        else
          puts "en.yml file not found"
        end

        @app.call(env)
      end

      private

      def generate_translations(locales_file)
        locales = YAML.load_file(locales_file)
        text_to_translate = locales.to_yaml
        generate_locales = I18nAi.configuration.generate_locales

        generate_locales.each do |locale|
          # Make a request to OpenAI to translate the locales to the specified locale
          response = @client.chat(
            parameters: {
              model: "gpt-4o-mini",
              messages: [{ role: "user",
                           content: "Translate the following YAML content to #{locale.to_s.upcase} and make sure to retain the keys in english except the first key which is the 2 letter language code:\n\n#{text_to_translate}" }],
              max_tokens: 5000
            }
          )

          translated_text = response["choices"][0]["message"]["content"]
          match_data = translated_text.match(/```yaml(.*?)```/m)
          str = match_data ? match_data[1].strip : nil

          # Save the response to <locale>.yml
          locales_file = Rails.root.join("config", "locales", "#{locale}.yml")
          File.write(locales_file, str)
        end
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
