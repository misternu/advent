require_relative 'bot'

describe Bot do
  describe '#new' do
    it 'initializes without options' do
      expect(Bot.new).to be_a Bot
    end
    it 'initializes with just a chip' do
      chips = [:one]
      bot = Bot.new({chips: chips})
      expect(bot.chips).to be chips
    end
    it 'initializes with just a high and low output' do
      outputs = {high: :one, low: :two}
      bot = Bot.new({outputs: outputs})
      expect(bot.outputs).to be outputs
    end
  end
  describe '#<<' do
    let(:bot) { Bot.new({chips:[1]}) }
    it 'takes in chips like an array' do
      expect{ bot << 2 }.to change{bot.chips}.from([1]).to([1,2])
    end
  end
  describe '#ready?' do
    let(:bot) { Bot.new({chips:[1,2], outputs:{high: :foo, low: :bar}}) }
    let(:bot2) { Bot.new }
    it 'returns true if the bot is ready' do
      expect(bot.ready?).to be true
    end
    it 'returns false if the bot is not ready' do
      expect(bot2.ready?).to be false
    end
  end
end