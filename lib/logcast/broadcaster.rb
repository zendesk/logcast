require 'logger'

class Logcast::Broadcaster
  def initialize(*subscribers)
    subscribers.each {|log| subscribe(log)}
  end

  def subscribe(subscriber)
    subscribers << subscriber unless subscribers.include?(subscriber)
  end

  def subscribers
    Thread.main[:logcast_subscribers] ||= []
  end

  def add(*args)
    subscribers.each do |subscriber|
      subscriber.add(*args)
    end
  end
end
