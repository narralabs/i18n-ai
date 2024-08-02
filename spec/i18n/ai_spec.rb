# frozen_string_literal: true

RSpec.describe I18n::Ai do
  it "has a version number" do
    expect(I18n::Ai::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end

  it "translates text to a different language" do
    result = I18n::Ai.translate('Hello', 'es')
    expect(result).to eq('Hola')
  end
end
