require File.expand_path('../test_helper', __FILE__)

describe Logcast do
  describe ".engage!" do
    after do
      Object.send(:remove_const, :Rails) if defined?(Rails)
      Object.send(:remove_const, :RAILS_DEFAULT_LOGGER) if defined?(RAILS_DEFAULT_LOGGER)
      Object.send(:remove_const, :ActiveRecord) if defined?(ActiveRecord)
    end

    it "hooks up Rails.logger" do
      class Fake
        def self.io
          @@io ||= StringIO.new
        end

        def self.logger
          @@logger ||= ActiveSupport::BufferedLogger.new(io)
        end
      end
      Object.const_set(:Rails, Fake)
      io2 = StringIO.new

      Logcast.engage!
      Rails.logger.subscribe(io2)
      Rails.logger.info("foo")

      Fake.io.string.must_include "foo"
      io2.string.must_include "foo"
    end

    if ActiveSupport::VERSION::STRING > "3.2"
      it "hooks up Rails.logger as TaggedLogging" do
        class Fake
          def self.io
            @@io ||= StringIO.new
          end

          def self.logger
            @@logger ||= ActiveSupport::TaggedLogging.new(ActiveSupport::BufferedLogger.new(io))
          end
        end
        Object.const_set(:Rails, Fake)
        io2 = StringIO.new

        Logcast.engage!
        Rails.logger.subscribe(io2)
        Rails.logger.info("foo")

        Fake.io.string.must_include "foo"
        io2.string.must_include "foo"
      end
    end

    it "hooks up RAILS_DEFAULT_LOGGER" do
      io1 = StringIO.new
      io2 = StringIO.new
      Object.const_set(:RAILS_DEFAULT_LOGGER, ActiveSupport::BufferedLogger.new(io1))

      Logcast.engage!

      RAILS_DEFAULT_LOGGER.subscribe(io2)
      RAILS_DEFAULT_LOGGER.info("foo")

      io1.string.must_include "foo"
      io2.string.must_include "foo"
    end

    it "hooks up ActiveRecord::Base.logger" do
      class Fake
        def self.io
          @@io ||= StringIO.new
        end

        def self.logger
          @@logger ||= ActiveSupport::BufferedLogger.new(io)
        end
      end
      Object.const_set(:ActiveRecord, Module.new)
      ActiveRecord.const_set(:Base, Fake)
      io2 = StringIO.new

      Logcast.engage!
      ActiveRecord::Base.logger.subscribe(io2)
      ActiveRecord::Base.logger.info("foo")

      Fake.io.string.must_include "foo"
      io2.string.must_include "foo"
    end
  end
end
