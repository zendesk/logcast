module Logcast
  autoload :Broadcaster, 'logcast/broadcaster.rb'

  def self.engage!
    logger = Rails.logger
    Rails.logger = Logcast::Broadcaster.new
    Rails.logger.subscribe(logger)
  end
end
