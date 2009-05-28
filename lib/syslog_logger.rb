require 'syslog'
require 'logger'

class SyslogLogger

  ##
  # The version of SyslogLogger you are using.

  VERSION = '1.4.2'

  # From 'man syslog.h':
  # LOG_EMERG   A panic condition was reported to all processes.
  # LOG_ALERT   A condition that should be corrected immediately.
  # LOG_CRIT    A critical condition.
  # LOG_ERR     An error message.
  # LOG_WARNING A warning message.
  # LOG_NOTICE  A condition requiring special handling.
  # LOG_INFO    A general information message.
  # LOG_DEBUG   A message useful for debugging programs.

  # From logger rdoc:
  # FATAL:  an unhandleable error that results in a program crash
  # ERROR:  a handleable error condition
  # WARN:   a warning
  # INFO:   generic (useful) information about system operation
  # DEBUG:  low-level information for developers

  ##
  # Maps Logger warning types to syslog(3) warning types.

  LOGGER_MAP = {
    :unknown => :alert,
    :fatal   => :alert,
    :error   => :err,
    :warn    => :warning,
    :info    => :info,
    :debug   => :debug
  }

  ##
  # Maps Logger log levels to their values so we can silence.

  LOGGER_LEVEL_MAP = {}

  LOGGER_MAP.each_key do |key|
    LOGGER_LEVEL_MAP[key] = Logger.const_get key.to_s.upcase
  end

  ##
  # Maps Logger log level values to syslog log levels.

  LEVEL_LOGGER_MAP = {}

  LOGGER_LEVEL_MAP.invert.each do |level, severity|
    LEVEL_LOGGER_MAP[level] = LOGGER_MAP[severity]
  end

  ##
  # Builds a methods for level +meth+.

  def self.make_methods(meth)
    eval <<-EOM, nil, __FILE__, __LINE__ + 1
      def #{meth}(message = nil)
        return true if #{LOGGER_LEVEL_MAP[meth]} < @level
        message ||= yield if block_given?
        if message
          SYSLOG.#{LOGGER_MAP[meth]} clean(message)
        end
        return true
      end

      def #{meth}?
        @level <= Logger::#{meth.to_s.upcase}
      end
    EOM
  end

  LOGGER_MAP.each_key do |level|
    make_methods level
  end

  ##
  # Log level for Logger compatibility.

  attr_accessor :level

  ##
  # Fills in variables for Logger compatibility.  If this is the first
  # instance of SyslogLogger, +program_name+ may be set to change the logged
  # program name.
  #
  # Due to the way syslog works, only one program name may be chosen.

  def initialize(program_name = 'rails')
    @level = Logger::DEBUG

    return if defined? SYSLOG
    self.class.const_set :SYSLOG, Syslog.open(program_name)
  end

  ##
  # Almost duplicates Logger#add.  +progname+ is ignored.

  def add(severity, message = nil, progname = nil, &block)
    severity ||= Logger::UNKNOWN
    return true if severity < @level
    message = clean(message || block.call)
    SYSLOG.send LEVEL_LOGGER_MAP[severity], clean(message)
    return true
  end

  ##
  # Allows messages of a particular log level to be ignored temporarily.
  #
  # Can you say "Broken Windows"?

  def silence(temporary_level = Logger::ERROR)
    old_logger_level = @level
    @level = temporary_level
    yield
  ensure
    @level = old_logger_level
  end

  private

  ##
  # Clean up messages so they're nice and pretty.

  def clean(message)
    message = message.to_s.dup
    message.strip!
    message.gsub!(/%/, '%%') # syslog(3) freaks on % (printf)
    message.gsub!(/\e\[[^m]*m/, '') # remove useless ansi color codes
    return message
  end

end

