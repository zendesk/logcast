require File.expand_path('../../test_helper', __FILE__)

describe Logcast::Broadcaster do
  let(:broadcaster){ Logcast::Broadcaster.new("/dev/null") }
  let(:stub){ Object.new }

  describe "#subscribe" do
    it "subscribes" do
      broadcaster.subscribe(stub)
      assert_equal [stub], broadcaster.subscribers
    end

    it "does not subscribe the same listener twice" do
      broadcaster.subscribe(stub)
      broadcaster.subscribe(stub)

      assert_equal [stub], broadcaster.subscribers
    end

    it "can subscribe with a block" do
      broadcaster.subscribe(stub) do
        assert_equal [stub], broadcaster.subscribers
      end
      assert_equal [], broadcaster.subscribers
    end

    it "unsubscribe with a block on exception" do
      assert_raises ArgumentError do
        broadcaster.subscribe(stub) do
          raise ArgumentError.new
        end
      end
      assert_equal [], broadcaster.subscribers
    end

    it "exeutes a block if the subscriber is already subscribed" do
      broadcaster.subscribe(stub)
      x = 2
      broadcaster.subscribe(stub) do
        x = 1
      end
      assert_equal 1, x
    end

    it "can subscribe with multiple blocks" do
      stub2 = Object.new
      broadcaster.subscribe(stub) do
        broadcaster.subscribe(stub2) do
          assert_equal [stub, stub2], broadcaster.subscribers
        end
        assert_equal [stub], broadcaster.subscribers
      end
      assert_equal [], broadcaster.subscribers
    end
  end

  it "logs via info" do
    recorder = StringIO.new

    broadcaster.subscribe(Logger.new(recorder))
    broadcaster.info("hello")

    assert_match /hello\n$/, recorder.string
  end

  it "logs via write" do
    recorder = StringIO.new

    broadcaster.subscribe(Logger.new(recorder))
    broadcaster.write("hello")

    assert_match /hello\n$/, recorder.string
  end
end
