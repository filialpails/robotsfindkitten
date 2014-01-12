require 'thread'
require 'drb/drb'
require_relative 'version'
require_relative 'thing_info'
require_relative 'nki'
require_relative 'robot'
require_relative 'kitten'

module RobotsFindKitten
  class Server
    def initialize
      @robots_mutex = Mutex.new
      @robots = {}
      @kitten = nil
      @nkis = []
      puts <<eos
robotsfindkitten #{RobotsFindKitten::VERSION}
By the illustrious Rob Steward (C) 2014
Based on robotfindskitten by Leonard Richardson

eos
      puts 'Server started.'
      reset
    end

    def join(name)
      puts "Join attempt from #{name}"
      robot = Robot.new(self)
      @robots_mutex.synchronize do
        if @robots.has_key?(name)
          puts "Robot named #{name} already in game."
          return
        end
        @robots[name] = robot
        puts "#{name} joined successfully."
      end
      robot
    end

    def leave(robot)
      @robots_mutex.synchronize do
        name = @robots.key(robot)
        @robots.delete_if {|k, v| v == robot}
        puts "#{name} left the game."
      end
    end

    def things
      things_internal.map do |thing|
        ThingInfo.new(thing.x, thing.y, thing.symbol)
      end
    end

    def occupied?(x, y)
      thing = things_internal.find do |thing|
        thing.x == x && thing.y == y
      end
      message = nil
      case thing
      when Kitten
        message = 'You found kitten! Way to go, robot!'
        reset
      when Robot
        message = 'It\'s another robot looking for kitten. Good luck, robot!'
      when NKI
        message = thing.message
      end
      message
    end

    private

    def things_internal
      (@robots.values + [@kitten] + @nkis)
    end

    def reset
      @kitten = Kitten.new
      @nkis = (0...20).map {|i| NKI.new}
      puts 'Game reset.'
    end
  end
end
