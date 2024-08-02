# frozen_string_literal: true

require "spec_helper"

RSpec.describe I18nAi::Configuration do
  it "has a default value for generate_locales" do
    expect(I18nAi.configuration.generate_locales).to eq([:es])
  end

  it "has a default value for source_locale" do
    expect(I18nAi.configuration.source_locale).to eq(:en)
  end

  it "uses the OPENAPI_API_KEY environment variable as the default value for openai_api_key" do
    expect(I18nAi.configuration.openai_api_key).to be_present
  end
end
