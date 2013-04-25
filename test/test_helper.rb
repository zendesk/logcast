require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/rg'
require 'debugger'

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'logcast'
