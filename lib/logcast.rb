module Logcast
  autoload :Broadcaster, 'logcast/broadcaster.rb'

  def self.engage!
    original = Rails.method(:logger=)

    Rails.define_singleton_method(:logger=) do |logger|
      broadcast = Logcast::Broadcaster.new
      broadcast.subscribe(logger)
      original.call(broadcast)
    end
  end
end
