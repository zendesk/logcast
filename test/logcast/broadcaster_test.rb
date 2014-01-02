require File.expand_path('../../test_helper', __FILE__)

describe Logcast::Broadcaster do
  let(:broadcaster){ Logcast::Broadcaster.new }
  let(:stub){ StringIO.new }

  describe "#subscribe" do
    it "subscribes" do
      broadcaster.subscribe(stub)
      assert_equal [stub], subscribers(broadcaster)
    end

    it "does not subscribe the same listener twice" do
      broadcaster.subscribe(stub)
      broadcaster.subscribe(stub)

      assert_equal [stub], subscribers(broadcaster)
    end

    it "can subscribe with a block" do
      broadcaster.subscribe(stub) do
        assert_equal [stub], subscribers(broadcaster)
      end
      assert_equal [], subscribers(broadcaster)
    end

    it "unsubscribe with a block on exception" do
      assert_raises ArgumentError do
        broadcaster.subscribe(stub) do
          raise ArgumentError.new
        end
      end
      assert_equal [], subscribers(broadcaster)
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
      stub2 = StringIO.new
      broadcaster.subscribe(stub) do
        broadcaster.subscribe(stub2) do
          assert_equal [stub, stub2], subscribers(broadcaster)
        end
        assert_equal [stub], subscribers(broadcaster)
      end
      assert_equal [], subscribers(broadcaster)
    end
  end

  [:stringio, :logger, :buffered_logger].each do |type|
    describe "logging to #{type}" do
      let(:recorder) { StringIO.new }
      let(:logger) do
        case type
        when :stringio then recorder
        when :logger then Logger.new(recorder)
        when :buffered_logger then ActiveSupport::BufferedLogger.new(recorder)
        else raise "Unsupported #{type}"
        end
      end

      it "logs via add" do
        broadcaster.subscribe(logger)
        broadcaster.add(1, "hello")

        recorder.string.must_include "hello"
        recorder.string.wont_include "\n\n"
      end
    end
  end
end
