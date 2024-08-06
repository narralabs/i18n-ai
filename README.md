# i18n-ai

i18n-ai is a gem that converts your rails locales into different languages automatically. Uses the `en.yml` file as base by default and creates accompanying `es.yml`, `it.yml` and others depending on your configuration.

Currently uses OpenAI (`gpt4o-mini`) to generate the translations but support for other AI models and APIs will be added soon.

## Installation

Simply add to your gemfile:

```
gem "i18n-ai"
```

And do `bundle install`.

## Configuration

To use I18nAi, you need to set the appropriate environment variables based on the AI service you wish to use.

### OpenAi

If you are using OpenAI, set `ENV["OPENAI_ACCESS_TOKEN"]`

To configure and enable other locales, create a file `config/initializers/i18n_aii.rb` and add the following:

```
# config/initializers/i18n_ai.rb
I18nAi.configure do |config|
  config.ai_settings = {
    provider: "openai",
    model: "gpt-4o-mini",
    access_token: ENV["OPENAI_ACCESS_TOKEN"]
  }
  config.generate_locales = [:es, :it] # add your other supported locales to this array
end
```

### Anthropic's Claude

If you prefer to use Anthropic's Claude, set `ENV[ANTHROPIC_API_KEY]`

To configure and enable other locales, create a file `config/initializers/i18n_ai.rb` and add the following:

```
I18nAi.configure do |config|
  config.ai_settings = {
    provider: "anthropic",
    model: "claude-3-haiku-20240307",
    access_token: ENV["ANTHROPIC_ACCESS_TOKEN"]
  }
  config.generate_locales = [:es]
end
```

### Local

If you prefer to use local AI models.

To configure and enable other locales, create a file `config/initializers/i18n_ai.rb` and add the following:

```
I18nAi.configure do |config|
  config.ai_settings = {
    provider: "local",
    model: "mistral",
    url: "http://localhost:11434/api/generate",
    method: "POST"
  }
  config.generate_locales = [:es]
end
```

## Usage

Every page reload, the gem will check if the `en.yml` file changed and if it did, it will automatically generate the configured locale files.

The gem has been setup to generate a `es.yml` file by default.

To disable locale generation simply set the `generate_locales` to an empty array.

```
I18nAi.configure do |config|
  config.generate_locales = []
end
```

## Development

If you are working on the gem itself, after checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.



To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the I18n::Ai project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/i18n-ai/blob/master/CODE_OF_CONDUCT.md).
