class Logcast::Broadcaster
  def subscribe(subscriber, &block)
    unless subscriber.respond_to?(:add)
      original_subscriber = subscriber
      subscriber = Logger.new(subscriber)
      subscriber.instance_variable_set(:@logcast_original_subscriber, original_subscriber)
    end

    if block
      if already_subscribed?(subscriber)
        yield
      else
        begin
          subscribers << subscriber
          yield
        ensure
          subscribers.pop
        end
      end
    else
      subscribers << subscriber unless already_subscribed?(subscriber)
    end
  end

  def subscribers
    @subscribers ||= []
  end

  def method_missing(name, *args, &block)
    responded = false

    subscribers.each do |subscriber|
      if subscriber.respond_to?(name)
        responded = true
        subscriber.send(name, *args, &block)
      end
    end

    super unless responded
  end

  private

  def already_subscribed?(logger)
    subscribers.map { |s| log_device(s) }.include?(log_device(logger))
  end

  def log_device(logger)
    logger.instance_variable_get(:@logcast_original_subscriber) || logger
  end
end
