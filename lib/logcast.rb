module Logcast
  autoload :Broadcaster, 'logcast/broadcaster.rb'

  def self.engage!
    class << Rails
      alias_method(:old_logger=, :logger=)

      def logger=(logger)
        broadcast = Logcast::Broadcaster.new
        broadcast.subscribe(logger)
        self.old_logger = broadcast
      end
    end
  end
end
