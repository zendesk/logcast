require 'logcast'

module Logcast
  class Railtie < Rails::Railtie
    initializer 'logcast.initialize', :before => :initialize_logger do |app|
      original = Rails.method(:logger=)

      Rails.define_singleton_method(:logger=) do |logger|
        broadcast = Logcast::Broadcaster.new
        broadcast.subscribe(logger)
        original.call(broadcast)
      end
    end
  end
end
