# frozen_string_literal: true

require "spec_helper"

RSpec.describe I18nAi::Railtie do
  it "inserts I18nAi::Railtie::I18nAiMiddleware into the middleware stack before build_middleware_stack" do
    app = double("app")
    middleware = double("middleware")
    allow(app).to receive(:middleware).and_return(middleware)
    allow(middleware).to receive(:use).with(I18nAi::Middleware)

    I18nAi::Railtie.initializers.find { |i| i.name == "i18n_ai.configure_middleware" }.block.call(app)

    expect(middleware).to have_received(:use).with(I18nAi::Middleware)
  end
end
