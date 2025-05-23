require File.expand_path('../test_helper', __FILE__)

describe Logcast do
  describe ".engage!" do
    after do
      Object.send(:remove_const, :Rails) if defined?(Rails)
    end

    it "hooks up Rails.logger" do
      class Fake
        def self.io
          @@io ||= StringIO.new
        end

        def self.logger
          @@logger
        end

        def self.logger=(logger)
          @@logger = logger
        end
      end

      Object.const_set(:Rails, Fake)
      io2 = StringIO.new

      Logcast.engage!
      Rails.logger = Logger.new(Fake.io)
      Rails.logger.subscribe(io2)
      Rails.logger.info("foo")

      assert_includes(Fake.io.string, "foo")
      assert_includes(io2.string, "foo")
    end
  end
end
