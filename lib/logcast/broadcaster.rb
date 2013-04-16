require 'logger'

class Logcast::Broadcaster < ::Logger
  def initialize(io, *args)
    if io.is_a?(Logger)
      @logdev = io.instance_variable_get(:@logdev)

      self.level = io.level
      self.formatter = io.formatter
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

  def add(*args)
    super

    subscribers.each do |subscriber|
      subscriber.add(*args)
    end
  end
end
