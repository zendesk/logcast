class Logcast::Broadcaster
  undef_method :silence if defined?(silence)

  def subscribe(subscriber, &block)
    unless subscriber.respond_to?(:add)
      original_subscriber = subscriber
      subscriber = Logger.new(subscriber)
      subscriber.instance_variable_set(:@logcast_original_subscriber, original_subscriber)
    end

    # Apply existing level to the new subscriber.
    if subscribers.any?
      subscriber.level = subscribers.first.level
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
    responding = subscribers.select { |s| s.respond_to?(name) }
    if responding.any?
      responding.map { |s| s.send(name, *args, &block) }.last
    else
      super
    end
  end

  def respond_to_missing?(name, include_all)
    subscribers.any? { |s| s.respond_to?(name) } || super
  end

  # Kernel#warn is defined by Ruby
  def warn(*args, &block)
    method_missing("warn", *args, &block)
  end

  private

  def already_subscribed?(logger)
    subscribers.map { |s| log_device(s) }.include?(log_device(logger))
  end

  def log_device(logger)
    logger.instance_variable_get(:@logcast_original_subscriber) || logger
  end
end
