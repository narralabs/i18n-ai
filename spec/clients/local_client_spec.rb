# frozen_string_literal: true

module I18nAi
  module Clients
    RSpec.describe LocalClient do
      let(:config) { {
        provider: "local",
        model: "mistral",
        url: "http://localhost:11434/api/generate"
      } }
      let(:client) { described_class.new }

      before do
        allow(I18nAi).to receive_message_chain(:configuration, :ai_settings).and_return(config)
      end

      describe "#initialize" do
        # No need to test for initialize
      end

      describe "#chat" do
        let(:locale) { :fr }
        let(:text) { "en: greeting: Good morning, welcome back!" }
        let(:response) { { "response" => "es: greeting: Bienvenido de nuevo!. buenas mañanas." } }

        before do
          allow_any_instance_of(Net::HTTP).to receive(:request).and_return(double(body: response.to_json))
        end

        it "sends a request to the local client" do
          expect_any_instance_of(Net::HTTP::Post).to receive(:body=).with(
            a_string_including("Translate the following YAML content")
          )
          client.chat(locale, text)
        end

        it "returns the parsed response" do
          expect(client.chat(locale, text)).to eq("es: greeting: Bienvenido de nuevo!. buenas mañanas.")
        end

        context "when an error occurs" do
          before do
            allow_any_instance_of(Net::HTTP).to receive(:request).and_raise(StandardError.new("test error"))
          end

          it "handles the error" do
            expect(client).to receive(:handle_error).with(an_instance_of(StandardError))
            client.chat(locale, text)
          end
        end
      end

      describe "#parse_response" do
        let(:response) { { "response" => "es: greeting: Bienvenido de nuevo!. buenas mañanas." } }

        it "parses the response correctly" do
          expect(client.send(:parse_response, response)).to eq("es: greeting: Bienvenido de nuevo!. buenas mañanas.")
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