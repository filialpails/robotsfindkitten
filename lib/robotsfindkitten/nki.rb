require_relative 'thing'

module RobotsFindKitten
  def self.load_nkis(filename)
    array = File.readlines(filename)
    array.delete_if {|line| line.start_with?('#')}
  end

  NKIS = load_nkis(File.join('data', 'vanilla.nki'))

  class NKI < Thing
    attr_reader :message

    def initialize
      super
      @message = NKIS.sample
    end
  end
end
