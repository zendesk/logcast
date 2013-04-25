require File.expand_path('../test_helper', __FILE__)
require 'active_support'

describe "Broadcasting" do
  let(:logger){
    logger = ActiveSupport::BufferedLogger.new(STDERR)
    logger.extend(Logcast::Broadcast)
    logger
  }

  it "responds to subscribe" do
    assert logger.respond_to?(:subscribe)
  end

  it "has subscribers" do
    assert_equal [], internal_log.subscribers
  end

  it "can subscribe" do
    new_log = Object.new
    logger.subscribe(new_log)
    assert_includes internal_log.subscribers, new_log
  end

  it "adds itself as logger instance" do
    assert_instance_of Logcast::Broadcaster, internal_log
  end

  private

  def internal_log
    logger.instance_variable_get(:@log)
  end
end
