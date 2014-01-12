require 'drb/drb'
require 'curses'
require_relative 'version'
require_relative 'thing_info'

module RobotsFindKitten
  class Client
    def initialize
      @message = ''
      @things = []
      @exit = false
      @move_up = false
      @move_down = false
      @move_left = false
      @move_right = false
      @local_service = nil
      @server = nil
      @robot = nil
    end

    def connect
      host = nil
      until host
        print 'Enter host: '
        host = gets
      end
      host.chomp!
      puts "Connecting to #{host}..."
      @local_service = DRb.start_service
      @server = DRbObject.new_with_uri("druby://#{host}:50293")
      puts "Connected."
      until @robot
        name = nil
        until name
          print 'Enter name: '
          name = gets
        end
        puts 'Joining...'
        @robot = @server.join(name.chomp)
        puts 'Name in use' unless @robot
      end
    end

    def start
      Curses.init_screen
      Curses.start_color
      Curses.crmode
      Curses.noecho
      Curses.stdscr.keypad = true
      Curses.curs_set(0)
      Curses.clear
      Curses.setpos(0, 0)
      Curses.addstr(<<eos)
robotsfindkitten #{RobotsFindKitten::VERSION}
By the illustrious Rob Steward (C) 2014
Based on robotfindskitten by Leonard Richardson

In this game, you are robot (#). Your job is to find kitten. This task
is complicated by the existence of various things which are not kitten.
Robot must touch items to determine if they are kitten or not. The game
does not end when robotfindskitten. You may end the game by hitting the
q key or a good old-fashioned Ctrl-C.

See the documentation for more information.

Press any key to start.
eos
      Curses.getch
      Curses.clear
      Curses.timeout = 0

      update_interval = 1.0 / 60.0
      until @exit
        start_time = Time.now
        update
        draw
        input
        end_time = Time.now
        diff = (end_time - start_time)
        if start_time <= end_time && diff < update_interval
          sleep(update_interval - diff)
        end
      end
    ensure
      @server.leave(@robot)
      Curses.close_screen
    end

    private

    def input
      @move_up = false
      @move_down = false
      @move_left = false
      @move_right = false
      case Curses.getch
      when 'w', Curses::KEY_UP then @move_up = true
      when 'a', Curses::KEY_LEFT then @move_left = true
      when 's', Curses::KEY_DOWN then @move_down = true
      when 'd', Curses::KEY_RIGHT then @move_right = true
      when 'q' then @exit = true
      end
    end

    def update
      @robot.move_up if @move_up
      @robot.move_down if @move_down
      @robot.move_left if @move_left
      @robot.move_right if @move_right
      @things = @server.things
      @message = @robot.message
    end

    def draw
      Curses.clear
      @things.each do |thing|
        Curses.setpos(thing.y, thing.x)
        Curses.addch(thing.symbol)
      end
      Curses.setpos(23, 0)
      Curses.addstr(@message)
      Curses.refresh
    end
  end
end
