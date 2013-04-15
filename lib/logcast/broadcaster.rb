require 'logger'

class Logcast::Broadcaster < ::Logger
  def broadcast(log)
    raise(ArgumentError, "Log does not respond to #add") unless log.respond_to?(:add)
    logs << log unless logs.include?(log)
  end

  def logs
    Thread.main[:logs] ||= []
  end

  %w{add << close flush level= formatter= progname=}.each do |method|
    define_method method do |*args, &block|
      logs.each {|log| log.send(method, *args, &block)}
      super(*args, &block)
    end
  end

  # IO-like
  def path
    @logdev.dev.path
  end

  # Needed for ActiveSupport::BufferedLogger's duck-typing check
  alias :write :<<
end
