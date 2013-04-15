require 'logger'

class Logcast::Broadcaster < ::Logger
  def initialize(*)
    super

    @logs = []
  end

  def broadcast(log)
    warn "Log does not respond to #add" unless log.respond_to?(:add)

    @logs << log
  end

  %w{add << close flush level= formatter= progname=}.each do |method|
    define_method :method do |*args, &block|
      super
      @logs.each {|log| log.send(method, *args, &block)}
    end
  end
end
