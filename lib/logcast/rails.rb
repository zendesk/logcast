require 'logcast'
Logcast.engage!

if defined?(Rails::VERSION::MAJOR) && Rails::VERSION::MAJOR == 3
  # Rails 3 bug, method missing is delegated without a block :/
  ActiveSupport::TaggedLogging.class_eval do
    def method_missing(method, *args, &block)
      @logger.send(method, *args, &block)
    end
  end
end
