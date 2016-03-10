class Game
  def initialize

  end

  def start
    loop do
      display_menu
      response = get_response.to_i
      if response == 1
        @deck = Deck.new
        @deck.shuffle
        @player = Player.new("Player")
        @dealer = Player.new("Dealer")
        setup_game
        loop do
          show_scores
          if @playerscore >21
            puts "You have busted!"
            exit
          elsif @continuance.upcase =="Y"
            play_game
          elsif @continuance.upcase == "N"
            puts "Standing"
            dealer_turn
            exit
          else
            puts "Invalid entry"
            play_game
          end
        end
      else
        puts "Goodbye"
        exit
      end

    end

  end

  def setup_game
    @continuance = "y"
    @playerhand = []
    @dealerhand = []
    @playerscore = 0
    @dealerscore = 0
    @playerhand.push @deck.deal
    @dealerhand.push @deck.deal
    @playerscore += @playerhand[-1].points
    @dealerscore += @dealerhand[-1].points
    @playerhand.push @deck.deal
    @dealerhand.push @deck.deal
    @playerscore += @playerhand[-1].points
    @dealerscore += @dealerhand[-1].points
  end

  def show_scores
    system('clear')
    line_bar
    puts @player.name
    @playerhand.each {|x| x.show_card}
    puts @playerscore
    line_bar
    puts @dealer.name
    @dealerhand[0].show_card
    line_bar
    puts
  end

  def play_game

    puts
    puts "Would you like another card?"
    @continuance = get_response("(Y)es or (N)o")
    if @continuance.upcase == "Y"
      @playerhand.push @deck.deal
      @playerscore += @playerhand[-1].points
    end
  end

  def dealer_turn
    while @dealerscore < 16
      @dealerhand.push @deck.deal
      @dealerscore += @dealerhand[-1].points
    end
    show_scores
    puts "Dealer stands"
  end

  def evaluate_match

  end

  def line_bar(length = 20)
    puts "-" * length
  end

  def display_menu
    puts "Let's Play Blackjack!"
    puts "-" * 20
    puts "1 - Play a Game"
    puts "2 - View the Stats(INACTIVE)"
    puts "Q - Quit(DISABLED)"
  end

  def get_response(prompt = "")
    print "#{prompt} > "
    gets.chomp
  end
end

class Player
  attr_accessor :name, :score
  def initialize(name)
    @name = name
    @wins = 0
  end
end

class Card
  attr_accessor :suit, :value
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def points
    case @value
    when 11, 12, 13 then @points = 10
    when 14 then @points = 11
    else @points = @value
    end
  end
  def show_card
    print @suit.to_s + ": "
    case @value
    when 11
      @status = "J"
    when 12
      @status = "Q"
    when 13
      @status = "K"
    when 14
      @status = "A"
    else
      @status = @value
    end
    puts @status
  end
end

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

Game.new.start
