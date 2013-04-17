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

  # Rails 3
  def add(*args)
    super

    subscribers.each do |subscriber|
      subscriber.add(*args)
    end
  end

  # Rails 2
  def write(msg)
    self << msg

    subscribers.each do |subscriber|
      if subscriber.respond_to?(:write)
        subscriber.write(msg)
      else
        subscriber.add(level, msg, progname)
      end
    end
  end
end
