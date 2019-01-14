require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/rg'

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'logcast'
require 'logger'
require 'active_support/version'

# For Kernel#silence
require 'active_support/core_ext/kernel/reporting'

def subscribers(broadcaster)
  broadcaster.subscribers.map {|s| broadcaster.send(:log_device, s)}
end
