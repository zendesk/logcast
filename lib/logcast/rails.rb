require 'logcast'

module Logcast
  class Railtie < Rails::Railtie
    config.before_configuration do
      Logcast.engage!
    end
  end
end
