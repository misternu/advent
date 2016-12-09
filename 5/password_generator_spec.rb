require_relative 'password_generator'

describe PasswordGenerator do
  describe '#generate' do
    let(:generator) { PasswordGenerator.new }
    it 'makes the password "05ace8e3" for door "abc"' do
      expect(generator.generate('abc')).to eq '05ace8e3'
    end
  end
end