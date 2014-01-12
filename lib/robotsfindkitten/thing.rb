module RobotsFindKitten
  WIDTH = 80
  HEIGHT = 23
  ALPHABET = ('!'..'~').to_a

  class Thing
    attr_reader :symbol, :x, :y

    def initialize
      symbol = '#'
      symbol = ALPHABET.sample while symbol == '#'
      @symbol = symbol
      @x = rand(WIDTH)
      @y = rand(HEIGHT)
    end
  end
end
