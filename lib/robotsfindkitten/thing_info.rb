module RobotsFindKitten
  class ThingInfo
    attr_reader :x, :y, :symbol

    def initialize(x, y, symbol)
      @x = x
      @y = y
      @symbol = symbol
    end
  end
end
