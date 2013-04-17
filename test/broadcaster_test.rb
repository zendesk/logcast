require 'test_helper'

class BroadcasterTest < Test::Unit::TestCase
  def setup
    @broadcaster = Logcast::Broadcaster.new("/dev/null")
  end

  def test_subscribe
    @broadcaster.subscribe(stub = Object.new)
    assert_equal [stub], @broadcaster.subscribers
  end

  def test_duplicate_subscribe
    stub = Object.new

    @broadcaster.subscribe(stub)
    @broadcaster.subscribe(stub)

    assert_equal [stub], @broadcaster.subscribers
  end

  def test_add
    recorder = StringIO.new

    @broadcaster.subscribe(Logger.new(recorder))
    @broadcaster.info("hello")

    assert_match /hello\n$/, recorder.string
  end

  def test_write
    recorder = StringIO.new

    @broadcaster.subscribe(Logger.new(recorder))
    @broadcaster.write("hello")

    assert_match /hello\n$/, recorder.string
  end
end
