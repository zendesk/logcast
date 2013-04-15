module Logcast::Broadcast
  def broadcast(*args)
    if @log.respond_to?(:broadcast)
      @log.broadcast(*args)
    end
  end
end
