require 'logcast'

logger = if defined?(Rails.logger)
  Rails.logger
elsif defined?(RAILS_DEFAULT_LOGGER)
  RAILS_DEFAULT_LOGGER
else
  ActiveRecord::Base.logger
end

logger.extend(Logcast::Broadcast)
