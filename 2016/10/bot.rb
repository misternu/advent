class Bot
  attr_accessor :outputs
  attr_reader :chips
  def initialize(options = {})
    @chips = options.fetch(:chips, [])
    @outputs = options.fetch(:outputs, {})
  end

  def <<(chip)
    self.chips << chip
  end

  def ready?
    self.chips.length >= 2
  end

  def execute
    self.outputs[:low] << @chips.min
    self.outputs[:high] << @chips.max
    self.chips = []
  end

  private

  attr_writer :chips
end