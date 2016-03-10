class Deck
  attr_reader :cards
  def initialize
    @cards = []
    suits = [:hearts, :diamonds, :spades, :clubs]
    suits.each do |suit|
      (2..14).each do |value|
        @cards << Card.new(suit, value)
      end
    end
    @cards
  end

  def show
    @cards.each do |card|
      puts card.value
    end
  end

  def shuffle
    @cards = @cards.shuffle
  end
  def deal
    @cards.shift
  end
end
