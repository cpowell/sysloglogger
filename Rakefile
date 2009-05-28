require 'rubygems'
require 'rake'
require 'echoe'
require './lib/syslog_logger.rb'

Echoe.new('SyslogLogger', SyslogLogger::VERSION) do |p|
  p.author = 'Eric Hodel; Chris Powell; Matthew Boeh'
  p.email = 'drbrain@segment7.net; cpowell@prylis.com; mboeh@desperance.net'
  p.description = "An improved Logger replacement that logs to syslog. It is almost drop-in with a few caveats."
  p.url = "http://github.com/mboeh/sysloglogger"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
