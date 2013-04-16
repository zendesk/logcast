class Logcast::Broadcaster
  def initialize(*init)
    init.each {|s| subscribe(s)}
  end

  def subscribe(subscriber)
    subscribers << subscriber unless subscribers.include?(subscriber)
  end

  def subscribers
    @subscribers ||= []
  end

  def add(*args)
    subscribers.each do |subscriber|
      subscriber.add(*args)
    end
  end
end
