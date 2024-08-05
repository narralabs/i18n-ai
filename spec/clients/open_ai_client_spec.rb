# frozen_string_literal: true

module I18nAi
  module Clients
    RSpec.describe OpenAiClient do
      let(:config) { { access_token: "test_token", model: "test_model" } }
      let(:client) { described_class.new }

      before do
        allow(I18nAi).to receive_message_chain(:configuration, :ai_settings).and_return(config)
      end

      describe "#initialize" do
        it "initializes the OpenAI client with the correct access token" do
          expect(OpenAI::Client).to receive(:new).with(access_token: config[:access_token], log_errors: true)
          client
        end
      end

      describe "#chat" do
        let(:locale) { :fr }
        let(:text) { "some text" }
        let(:response) { { "choices" => [{ "message" => { "content" => "translated text" } }] } }

        before do
          allow_any_instance_of(OpenAI::Client).to receive(:chat).and_return(response)
        end

        it "sends a message to the OpenAI client" do
          expect_any_instance_of(OpenAI::Client).to receive(:chat).with(
            parameters: {
              model: config[:model],
              messages: [{ role: "user", content: client.send(:content, locale, text) }],
              max_tokens: 5000
            }
          )
          client.chat(locale, text)
        end

        it "returns the parsed response" do
          expect(client.chat(locale, text)).to eq("translated text")
        end

        context "when an error occurs" do
          before do
            allow_any_instance_of(OpenAI::Client).to receive(:chat).and_raise(StandardError.new("test error"))
          end

          it "handles the error" do
            expect(client).to receive(:handle_error).with(an_instance_of(StandardError))
            client.chat(locale, text)
          end
        end
      end

      describe "#parse_response" do
        let(:response) { { "choices" => [{ "message" => { "content" => "translated text" } }] } }

        it "parses the response correctly" do
          expect(client.send(:parse_response, response)).to eq("translated text")
        end

        context "when the response is invalid" do
          let(:response) { nil }

          it "handles NoMethodError" do
            expect(client).to receive(:handle_error).with(an_instance_of(NoMethodError))
            client.send(:parse_response, response)
          end
        end
      end

      describe "#handle_error" do
        let(:error) { StandardError.new("test error") }

        it "prints the error message" do
          expect { client.send(:handle_error, error) }.to output("Error: test error\n").to_stdout
        end
      end
    end
  end
end
