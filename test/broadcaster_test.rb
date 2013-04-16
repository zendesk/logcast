require 'test_helper'

class BroadcasterTest < Test::Unit::TestCase
  def setup
    @broadcaster = Logcast::Broadcaster.new
  end

  def test_setup
    stub = Object.new

    broadcaster = Logcast::Broadcaster.new(stub, stub)
    assert_equal [stub], broadcaster.subscribers
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
    @broadcaster.add(0, "hello", "myprog")

    assert_equal "hello\n", recorder.string
  end
end
