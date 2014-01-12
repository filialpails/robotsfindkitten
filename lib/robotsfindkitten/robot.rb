require 'drb/drb'
require_relative 'thing'

module RobotsFindKitten
  class Robot < Thing
    include DRb::DRbUndumped

    attr_reader :message
    attr_accessor :on_find_kitten

    def initialize(server)
      super()
      @symbol = '#'
      @message = ''
      @server = server
    end

    def move_up
      move(0, -1)
    end

    def move_down
      move(0, 1)
    end

    def move_left
      move(-1, 0)
    end

    def move_right
      move(1, 0)
    end

    private

    def move(dx, dy)
      new_x = @x + dx
      new_y = @y + dy
      message = @server.occupied?(new_x, new_y)
      if message
        @message = message
      else
        @x = new_x % WIDTH
        @y = new_y % HEIGHT
      end
    end
  end
end
