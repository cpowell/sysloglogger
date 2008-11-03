Gem::Specification.new do |s|
  s.name     = "SyslogLogger"
  s.version  = "1.4.1"
  s.date     = "2008-11-01"
  s.summary  = "Logger replacement that logs to syslog"
  s.email    = "cpowell@prylis.com"
  s.homepage = "http://github.com/cpowell/sysloglogger"
  s.description = "SyslogLogger is a Logger replacement that logs to syslog. It is almost drop-in with a few caveats. You can add SyslogLogger to your Rails production environment to aggregate logs between multiple machines."
  s.has_rdoc = true
  s.authors  = ["Eric Hodel", "Chris Powell"]
  s.files    = ["History.txt", 
		"Manifest.txt", 
		"README.txt",
		"README.rdoc", 
		"Rakefile", 
		"sysloglogger.gemspec", 
		"lib/syslog_logger.rb", 
		"lib/analyzer_tools/syslog_logger.rb"]
  s.test_files = ["test/test_syslog_logger.rb"]
  s.rdoc_options = ["--main", "README.txt"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
end
