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
