module Logcast
  autoload :Broadcaster, 'logcast/broadcaster.rb'
  autoload :Broadcast, 'logcast/broadcast.rb'

  def self.engage!
    logger = if defined?(Rails.logger)
      Rails.logger
    elsif defined?(RAILS_DEFAULT_LOGGER)
      RAILS_DEFAULT_LOGGER
    else
      ActiveRecord::Base.logger
    end

    logger = logger.instance_variable_get(:@logger) if logger.class.name == "ActiveSupport::TaggedLogging"

    logger.extend(Logcast::Broadcast)
  end
end
