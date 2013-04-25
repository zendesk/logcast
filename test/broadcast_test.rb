require File.expand_path('../test_helper', __FILE__)
require 'active_support'

describe "Broadcasting" do
  before do
    @logger = ActiveSupport::BufferedLogger.new(STDERR)
    @logger.extend(Logcast::Broadcast)
  end

  it "responds to subscribe" do
    assert @logger.respond_to?(:subscribe)
  end

  it "has subscribers" do
    assert_equal [], internal_log.subscribers
  end

  it "can subscribe" do
    @logger.subscribe(@new_log = Object.new)
    assert_includes internal_log.subscribers, @new_log
  end

  it "adds itself as logger instance" do
    assert_instance_of Logcast::Broadcaster, internal_log
  end

  private

  def internal_log
    @logger.instance_variable_get(:@log)
  end
end
