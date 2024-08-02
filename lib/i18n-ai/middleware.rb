# frozen_string_literal: true

module I18nAi
  class Middleware
    def initialize(app)
      @app = app
      @client = build_openai_client
      @last_checksum = nil
    end

    def call(env)
      translate_locale_files
      @app.call(env)
    end

    private

    attr_reader :last_checksum, :client

    def build_openai_client
      OpenAI::Client.new \
        access_token: I18nAi.configuration.openai_api_key,
        log_errors: true
    end

    def translate_locale_files
      return unless File.exist? locales_file

      file_changed = checksum(locales_file) != last_checksum
      return unless file_changed

      @last_checksum = checksum(locales_file)
      generate_translations(locales_file)
    end

    def locale_file_name
      "#{I18nAi.configuration.source_locale}.yml"
    end

    def locales_file
      Rails.root.join("config", "locales", locale_file_name)
    end

    def generate_translations(locales_file) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      text_to_translate = YAML.load_file(locales_file).to_yaml.chomp

      I18nAi.configuration.generate_locales.each do |locale|
        # Make a request to OpenAI to translate the locales to the specified locale
        # rubcop:disable Layout/LineLength
        response = client.chat(
          parameters: {
            model: "gpt-4o-mini",
            messages: [
              {
                role: "user",
                content: <<~TEXT
                  Translate the following YAML content to #{locale.to_s.upcase} and make sure to
                  retain the keys in english except the first key which is the 2 letter language
                  code:

                  #{text_to_translate}
                TEXT
              }
            ],
            max_tokens: 5000
          }
        )
        # rubcop:enable Layout/LineLength

        translated_text = response["choices"][0]["message"]["content"]
        match_data = translated_text.match(/```yaml(.*?)```/m)
        str = match_data ? match_data[1].strip : nil

        # Save the response to <locale>.yml
        locales_file = Rails.root.join("config", "locales", "#{locale}.yml")
        File.write(locales_file, str)
      end
    end

    def checksum(file_path)
      Digest::SHA256.file(file_path).hexdigest
    end
  end
end
