require 'logger'

class Logcast::Broadcaster < ::Logger
  def initialize(io, *args)
    if io.is_a?(Logger)
      @logdev = io.instance_variable_get(:@logdev)

      self.level = io.level
      self.formatter = io.formatter
      self.progname = io.progname
    else
      super
    end
  end

  def subscribe(subscriber)
    subscribers << subscriber unless subscribers.include?(subscriber)
  end

  def subscribers
    @subscribers ||= []
  end

  # Add for all loggers
  # Write for Rails 2.3 -> 3.1
  %w{add write}.each do |method|
    define_method method do |*args|
      super(*args)

      subscribers.each do |subscriber|
        subscriber.send(method, *args)
      end
    end
  end
end
