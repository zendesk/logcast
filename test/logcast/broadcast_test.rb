require File.expand_path('../../test_helper', __FILE__)

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
    assert_equal [], subscribers(internal_log)
  end

  it "can subscribe" do
    new_log = StringIO.new
    logger.subscribe(new_log)
    assert_includes subscribers(internal_log), new_log
  end

  it "adds itself as logger instance" do
    assert_instance_of Logcast::Broadcaster, internal_log
  end

  private

  def internal_log
    logger.instance_variable_get(:@log)
  end
end
