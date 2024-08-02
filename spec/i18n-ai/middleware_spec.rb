# frozen_string_literal: true

require "spec_helper"

RSpec.describe I18nAi::Middleware do
  subject(:instance) { described_class.new app }

  let(:rails_app_dir) { Pathname.new File.expand_path("../fixtures/app", __dir__) }
  let(:es_yml) { rails_app_dir.join("config", "locales", "es.yml") }
  let(:en_backup_yml) { rails_app_dir.join("config", "locales", "en.backup.yml") }
  let(:en_yml) { rails_app_dir.join("config", "locales", "en.yml") }

  before do
    allow(Rails).to receive(:root).and_return(rails_app_dir)

    FileUtils.cp en_backup_yml, en_yml unless en_yml.exist?
    es_yml.delete if es_yml.exist?
  end

  after do
    es_yml.delete if es_yml.exist?
  end

  describe "#call" do
    subject(:call) { instance.call app }

    let(:app) { double("app", call: nil) }
    let(:expected_parameters) do
      {
        model: "gpt-4o-mini",
        messages: [
          {
            role: "user",
            content: <<~TEXT
              Translate the following YAML content to ES and make sure to retain the keys in english except the first key which is the 2 letter language code:

              ---
              en:
                a: b
            TEXT
          }
        ],
        max_tokens: 5000
      }
    end

    it { expect { call }.to change { es_yml.exist? }.from(false).to(true) }

    it "calls the openapi client with the right parameters" do
      openai_client = double
      allow(OpenAI::Client).to receive(:new).and_return(openai_client)

      openai_response = { "choices" => [{ "message" => { "content" => "some string" } }] }
      allow(openai_client).to receive(:chat).with(parameters: expected_parameters).and_return openai_response

      call
      expect(openai_client).to have_received(:chat).with(parameters: expected_parameters)
    end

    context "without a en.yml file" do
      before { en_yml.delete if en_yml.exist? }

      it { expect { call }.not_to(change { es_yml.exist? }) }
    end

    context "with an invalid openapi_api_key" do
      before { I18nAi.configuration.openai_api_key = nil }

      it { expect { call }.to raise_error Faraday::UnauthorizedError }
    end
  end
end
