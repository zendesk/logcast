module Logcast::Broadcast
  def self.extended(obj)
    current_log = obj.instance_variable_get(:@log)
    obj.instance_variable_set(:@log, Logcast::Broadcaster.new(current_log))
  end

  def subscribe(*args)
    @log.subscribe(*args)
  end
end
