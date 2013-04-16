require 'test_helper'
require 'active_support'

class RailsTest < Test::Unit::TestCase
  def setup
    @logger = ActiveSupport::BufferedLogger.new(STDERR)
    @logger.extend(Logcast::Broadcast)
  end

  def test_respond_subscribe
    assert @logger.respond_to?(:subscribe)
  end

  def test_subscribers
    assert_equal [], internal_log.subscribers
  end

  def test_subscribe
    @logger.subscribe(@new_log = Object.new)
    assert_includes internal_log.subscribers, @new_log
  end

  def test_broadcaster_instance
    assert_instance_of Logcast::Broadcaster, internal_log
  end

  private

  def internal_log
    @logger.instance_variable_get(:@log)
  end
end
