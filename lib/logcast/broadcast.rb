module Logcast::Broadcast
  def self.extended(obj)
    current_log = obj.instance_variable_get(:@log)
    obj.instance_variable_set(:@log, Logcast::Broadcaster.new(current_log))
  end

  def broadcast(*args)
    @log.broadcast(*args)
  end
end
