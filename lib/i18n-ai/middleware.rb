# frozen_string_literal: true

module I18nAi
  class Middleware
    def initialize(app)
      @app = app
      @client = OpenAI::Client.new(
        access_token: I18nAi.configuration.openai_api_key,
        log_errors: true
      )
      @last_checksum = nil
    end

    def call(env) # rubocop:disable Metrics/MethodLength
      locale_file_name = "#{I18nAi.configuration.source_locale}.yml"
      locales_file = Rails.root.join("config", "locales", locale_file_name)

      if File.exist?(locales_file)
        current_checksum = calculate_checksum(locales_file)
        puts "==> #{locale_file_name} checksum: #{current_checksum}"
        first_load = @last_checksum.nil?
        file_changed = current_checksum != @last_checksum
        puts "==> #{locale_file_name} generate: #{first_load || file_changed}"

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

    def generate_translations(locales_file) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      locales = YAML.load_file(locales_file)
      text_to_translate = locales.to_yaml.chomp
      generate_locales = I18nAi.configuration.generate_locales

      generate_locales.each do |locale|
        # Make a request to OpenAI to translate the locales to the specified locale
        # rubcop:disable Layout/LineLength
        response = @client.chat(
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

    def calculate_checksum(file_path)
      Digest::SHA256.file(file_path).hexdigest
    end
  end
end
