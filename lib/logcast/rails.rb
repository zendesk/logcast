require 'logcast'

module Logcast
  class Railtie < Rails::Railtie
    initializer 'logcast.initialize', :before => :initialize_logger do |app|
      class << Rails
        def logger_with_logcast=(logger)
          broadcast = Logcast::Broadcaster.new
          broadcast.subscribe(logger)
          self.logger_without_broadcaster = broadcast
        end

        alias_method_chain :logger=, :logcast
      end
    end
  end
end
