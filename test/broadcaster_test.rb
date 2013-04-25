require File.expand_path('../test_helper', __FILE__)

describe Logcast::Broadcaster do
  before do
    @broadcaster = Logcast::Broadcaster.new("/dev/null")
  end

  it "subscribes" do
    @broadcaster.subscribe(stub = Object.new)
    assert_equal [stub], @broadcaster.subscribers
  end

  it "does not subscribe the same listener twice" do
    stub = Object.new

    @broadcaster.subscribe(stub)
    @broadcaster.subscribe(stub)

    assert_equal [stub], @broadcaster.subscribers
  end

  it "logs via info" do
    recorder = StringIO.new

    @broadcaster.subscribe(Logger.new(recorder))
    @broadcaster.info("hello")

    assert_match /hello\n$/, recorder.string
  end

  it "logs via write" do
    recorder = StringIO.new

    @broadcaster.subscribe(Logger.new(recorder))
    @broadcaster.write("hello")

    assert_match /hello\n$/, recorder.string
  end
end
