require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/rg'

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'logcast'
require 'active_support/buffered_logger'
require 'active_support/version'

def subscribers(broadcaster)
  broadcaster.subscribers.map {|s| broadcaster.send(:log_device, s)}
end
