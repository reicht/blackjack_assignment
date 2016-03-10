class Game
  def initialize

  end

  def start
    puts "What's your name player?"
    player = get_response("Name")
    @player = Player.new(player)
    @dealer = Player.new("Dealer")
    display_menu
  end

  def display_menu
    system('clear')
    line_bar
    puts "Let's Play Blackjack!"
    line_bar
    puts "1 - Play a Game"
    puts "2 - View the Stats(BETA)"
    puts "Q - Quit"
    line_bar
    response = get_response.to_i
    if response == 1
      setup_game
    elsif response == 2
      show_tallies
    else
      exit
    end
  end

  def show_tallies
    system('clear')
    line_bar
    print "Players Wins: "
    puts @player.wins
    line_bar
    print "House Wins: "
    puts @dealer.wins
    line_bar
    puts
    puts "(P)lay again, (B)ack to Menu, or e(X)it?"
    response = get_response
    if response.upcase == "P"
      setup_game
    elsif response.upcase == "B"
      display_menu
    elsif response.upcase == "X"
      exit
    else
      show_tallies
    end
  end

  def setup_game
    @continuance = "y"
    @deck = Deck.new
    @deck.shuffle
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
    @playerhand[0].value = 14
    @playerhand[1].value = 12
    black_jack_check
    turn_cycle

  end

  def player_win
    @player.wins += 1
    show_scoreboard
    puts @player.name + " WINS!!!"
    puts
    puts "(P)lay again, (B)ack to Menu, or e(X)it?"
    response = get_response
    if response.upcase == "P"
      setup_game
    elsif response.upcase == "B"
      display_menu
    elsif response.upcase == "X"
      exit
    else
      player_win
    end
  end

  def dealer_win
    @dealer.wins += 1
    show_scoreboard
    puts @dealer.name + " WINS!!!"
    puts
    puts "(P)lay again, (B)ack to Menu, or e(X)it?"
    response = get_response
    if response.upcase == "P"
      setup_game
    elsif response.upcase == "B"
      display_menu
    elsif response.upcase == "X"
      exit
    else
      dealer_win
    end
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

  def show_scoreboard
    system('clear')
    line_bar
    puts @player.name
    @playerhand.each {|x| x.show_card}
    puts @playerscore
    line_bar
    puts @dealer.name
    @dealerhand.each {|x| x.show_card}
    puts @dealerscore
    line_bar
    puts
  end

  def turn_cycle
    loop do
      show_scores
      if @playerscore >21
        puts "You have busted!"
        interceptor
        dealer_win
      elsif @continuance.upcase =="Y"
        player_hit
      elsif @continuance.upcase == "N"
        puts "Standing"
        interceptor
        dealer_turn
        exit
      else
        puts "Invalid entry"
        player_hit
      end
    end
  end

  def player_hit
    puts
    puts "Would you like another card?"
    @continuance = get_response("(Y)es or (N)o")
    if @continuance.upcase == "Y"
      @playerhand.push @deck.deal
      @playerscore += @playerhand[-1].points
    end
  end

  def dealer_turn
    show_scoreboard
    puts "The Dealer show cards"
    interceptor
    while @dealerscore < 16
      @dealerhand.push @deck.deal
      @dealerscore += @dealerhand[-1].points
      show_scoreboard
      puts "Standing"
      interceptor
    end
    show_scoreboard
    puts "Dealer stands"
    evaluate_match
  end

  def evaluate_match
    if @playerscore > @dealerscore || @dealerscore > 21
      player_win
    elsif @playerscore == @dealerscore
     show_scoreboard
     line_bar
     puts "DRAW GAME!! EVERYONE'S A LOSER!!"
    else
      dealer_win
    end
  end

  def black_jack_check
    if @playerhand[0].value == 14 && (@playerhand[1].value == 11 ||
       @playerhand[1].value == 12 ||
       @playerhand[1].value == 13)
       show_scoreboard
      puts "BLACKJACK!!  YOU WIN!!"
      interceptor
      player_win
    elsif @playerhand[1].value == 14 && (@playerhand[0].value == 11 ||
      @playerhand[0].value == 12 ||
      @playerhand[0].value == 13)
      show_scoreboard
      puts "BLACKJACK!!  YOU WIN!!"
      interceptor
      player_win
    end
  end

  def line_bar(length = 20)
    puts "-" * length
  end

  def get_response(prompt = "")
    print "#{prompt} > "
    gets.chomp
  end
  def interceptor
    puts "Enter anything to continue"
    get_response
  end
end

class Player
  attr_accessor :name, :wins
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
