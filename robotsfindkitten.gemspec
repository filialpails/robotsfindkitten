require_relative 'lib/robotsfindkitten/version'

Gem::Specification.new do |s|
  s.name = 'robotsfindkitten'
  s.version = RobotsFindKitten::VERSION

  s.summary = 'Multi-user zen simulation.'
  s.description = "In this game, you are robot (#). Your job is to find kitten. This task\nis complicated by the existence of various things which are not kitten.\nRobot must touch items to determine if they are kitten or not. The game\nends when robotfindskitten."

  s.author = 'Rob Steward'
  s.email = 'bobert_1234567890@hotmail.com'
  s.homepage = 'https://github.com/filialpails/robotsfindkitten'
  s.license = 'GPL-3.0'

  s.files = Dir['README.md', 'LICENSE', 'data/*.nki', 'lib/**/*.rb', 'bin/*']
  s.bindir = 'bin'
  s.executables = ['rfk-client', 'rfk-server']
  s.add_runtime_dependency 'curses', '~> 1.0'
end
