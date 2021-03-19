require File.expand_path('../../test_helper', __FILE__)

describe Logcast::Broadcaster do
  let(:broadcaster){ Logcast::Broadcaster.new }
  let(:stub1){ StringIO.new }
  let(:stub2){ StringIO.new }
  let(:logger){ Logger.new(StringIO.new) }
  let(:logger2){ Logger.new(StringIO.new) }

  describe "#silence" do
    before do
      def logger.silence; @called = true; end

      broadcaster.subscribe(logger)
    end

    it "passes silence through" do
      broadcaster.silence
      assert_equal true, logger.instance_variable_get(:@called)
    end
  end

  describe "#subscribe" do
    it "subscribes" do
      broadcaster.subscribe(stub1)
      assert_equal [stub1], subscribers(broadcaster)
    end

    it "does not subscribe the same listener twice" do
      broadcaster.subscribe(stub1)
      broadcaster.subscribe(stub1)

      assert_equal [stub1], subscribers(broadcaster)
    end

    it "can subscribe with a block" do
      broadcaster.subscribe(stub1) do
        assert_equal [stub1], subscribers(broadcaster)
      end
      assert_equal [], subscribers(broadcaster)
    end

    it "unsubscribe with a block on exception" do
      assert_raises ArgumentError do
        broadcaster.subscribe(stub1) do
          raise ArgumentError.new
        end
      end
      assert_equal [], subscribers(broadcaster)
    end

    it "executes a block if the subscriber is already subscribed" do
      broadcaster.subscribe(stub1)
      x = 2
      broadcaster.subscribe(stub1) do
        x = 1
      end
      assert_equal 1, x
    end

    it "can subscribe with multiple blocks" do
      broadcaster.subscribe(stub1) do
        broadcaster.subscribe(stub2) do
          assert_equal [stub1, stub2], subscribers(broadcaster)
        end
        assert_equal [stub1], subscribers(broadcaster)
      end
      assert_equal [], subscribers(broadcaster)
    end

    it "raises NoMethodError if nothing responds" do
      broadcaster.subscribe(stub1)
      assert_raises(NoMethodError) { broadcaster.notch }
    end

    it "doesn't raise NoMethodError if something responds" do
      broadcaster.subscribe(stub1)
      broadcaster.add(0, 'hi')
    end

    it "returns level correctly" do
      logger.level = Logger::DEBUG
      broadcaster.subscribe(logger)

      assert_equal broadcaster.level, logger.level
      assert_equal broadcaster.level, Logger::DEBUG
    end

    it "sets the same level on all subscribers" do

      logger.level = Logger::DEBUG
      logger2.level = Logger::INFO
      broadcaster.subscribe(logger)


      broadcaster.subscribe(logger2)
      assert_equal logger.level, logger2.level
      assert_equal logger.level, Logger::DEBUG
    end

    it "sets same levels on all subscribers" do
      logger.level = Logger::INFO
      logger2.level = Logger::INFO

      broadcaster.subscribe(logger)
      broadcaster.subscribe(logger2)

      broadcaster.level = Logger::DEBUG

      assert_equal logger.level, Logger::DEBUG
      assert_equal logger.level, Logger::DEBUG
    end

    it "sets level correctly on non-loggers" do
      logger.level = Logger::WARN

      broadcaster.subscribe(logger)
      broadcaster.subscribe(stub1)

      broadcaster.debug("hello")
      broadcaster.warn("warning you!")

      refute_includes(stub1.string, "hello")
      assert_includes(stub1.string, "warning you!")
    end

    it "overrides Kernel#warn" do
      logger.level = Logger::WARN

      broadcaster.subscribe(stub1)

      broadcaster.send(:warn, "warning you!")

      assert_includes(stub1.string, "warning you!")
    end
  end

  [:stringio, :logger].each do |type|
    describe "logging to #{type}" do
      let(:recorder) { StringIO.new }
      let(:stub_logger) do
        case type
        when :stringio then recorder
        when :logger then Logger.new(recorder)
        else raise "Unsupported #{type}"
        end
      end

      it "logs via add" do
        broadcaster.subscribe(stub_logger)
        broadcaster.add(1, "hello")

        assert_includes(recorder.string, "hello")
        refute_includes(recorder.string, "\n\n")
      end
    end
  end
end
